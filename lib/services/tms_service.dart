import 'dart:async';
import 'dart:convert';
import 'package:flutter_reflow/models/reflow_profile.dart';
import 'package:logging/logging.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_reflow/models/tms/tms_status.dart';
import 'package:flutter_reflow/models/tms/tms_log.dart';
import 'package:flutter_reflow/models/tms/tms_command.dart';

import 'package:flutter_gpiod/flutter_gpiod.dart';
import 'package:libserialport/libserialport.dart';

const sendTimeout = Duration(milliseconds: 100);
const tmsStaleTimeout = Duration(seconds: 2);
const tmsGracePeriod = Duration(seconds: 3);
final log = Logger('TmsService');

const Utf8Decoder utf8Decoder = Utf8Decoder(allowMalformed: true);

class TmsService extends ChangeNotifier {
  SerialPort? _serialPort;
  SerialPortReader? _serialPortReader;
  bool _isReconnectScheduled = false;
  bool _isConnected = false;
  Timer? _profileTimer;
  int _targetTemperature = 0;

  // default to date time epoch so that it's stale immediately
  DateTime _lastUpdated = DateTime.fromMillisecondsSinceEpoch(0);

  // chip 2, line 15
  final _tmsResetLine = FlutterGpiod.instance.chips[2].lines[15];

  final StreamController<TmsStatus> _statusStreamController =
      StreamController.broadcast();
  final StreamController<TmsLog> _logStreamController =
      StreamController.broadcast();

  Stream<TmsStatus> get statusStream => _statusStreamController.stream;

  Stream<TmsLog> get logStream => _logStreamController.stream;

  DateTime get lastUpdated => _lastUpdated;

  bool get healthy => DateTime.now().difference(_lastUpdated) < tmsStaleTimeout;

  bool get isConnected => _isConnected;

  bool get isProfileRunning => _profileTimer != null && _profileTimer!.isActive;

  set targetTemperature(int value) {
    _targetTemperature = value;
    notifyListeners();
  }

  int get targetTemperature => _targetTemperature;

  TmsService._() {
    _tmsResetLine.requestOutput(initialValue: true, consumer: 'flutter_reflow');
    _connect();
    DateTime lastReset = DateTime.now();
    // on an interval, check the lastUpdated time and if it's stale, reset the TMS
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!healthy && DateTime.now().difference(lastReset) > tmsGracePeriod) {
        log.severe('TMS is stale. Resetting...');
        lastReset = DateTime.now();
        reset();
      }
    });
    // send target temperature every 500ms
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_serialPort != null && _serialPort!.isOpen) {
        log.finest('Sending target temperature to TMS: $_targetTemperature');
        send(TemperatureCommand(_targetTemperature));
      }
    });
  }

  factory TmsService.connect() {
    log.config('Creating TmsService instance and attempting to connect.');
    return TmsService._();
  }

  void _connect() {
    _tmsResetLine.setValue(true);
    try {
      log.info('Attempting to connect to a serial port...');
      if (SerialPort.availablePorts.isEmpty) {
        log.warning('No serial ports found!');
        _scheduleReconnect();
        return;
      }

      final portName = SerialPort.availablePorts.first;
      log.info('Connecting to $portName');
      final serialPort = SerialPort(portName);

      if (!serialPort.openReadWrite()) {
        log.severe(
            'Failed to open serial port $portName! Retrying in 1 second...');
        _scheduleReconnect();
        return;
      }

      _serialPort = serialPort;
      _configureSerialPort();
      _startListening();
      log.info('Successfully connected to serial port $portName');
    } catch (e) {
      log.severe('Exception during serial port connection: $e');
      _scheduleReconnect();
    }
  }

  void _configureSerialPort() {
    final serialPort = _serialPort;
    if (serialPort == null) {
      log.warning('Serial port is null when attempting to configure.');
      return;
    }

    var config = serialPort.config;
    config.baudRate = 115200;
    config.bits = 8;
    config.stopBits = 1;
    config.parity = SerialPortParity.none;
    serialPort.config = config;
    log.config(
        'Serial port configured with baudRate: ${config.baudRate}, bits: ${config.bits}, stopBits: ${config.stopBits}, parity: ${config.parity}');
  }

  void _startListening() {
    final serialPort = _serialPort;
    if (serialPort == null) {
      log.warning('Attempted to listen on a null serial port.');
      return;
    }

    log.info('Starting to listen on the serial port...');
    _serialPortReader = SerialPortReader(serialPort);

    utf8Decoder
        .bind(_serialPortReader!.stream)
        .transform(const LineSplitter())
        .listen(
      (line) {
        _processSerialData(line);
      },
      onError: (error) {
        log.warning(
            'Error on serial port stream: $error. Attempting to reconnect...');
        _scheduleReconnect();
      },
      onDone: () {
        log.info('Serial port reader was closed.');
      },
    );
  }

  void _processSerialData(String line) {
    _lastUpdated = DateTime.now();
    if (!_isConnected) {
      _isConnected = true;
      notifyListeners();
    }
    log.finer('Received line: $line');
    try {
      var json = jsonDecode(line);
      if (json.containsKey('state')) {
        log.finer('Decoded TmsStatus from JSON.');
        _statusStreamController.add(TmsStatus.fromJson(json));
      } else if (json.containsKey('severity')) {
        log.finer('Decoded TmsLog from JSON.');
        _logStreamController.add(TmsLog.fromJson(json));
      } else {
        log.warning('Received JSON does not contain recognized keys.');
      }
    } catch (e) {
      log.warning('Error decoding JSON: $e for line: $line');
    }
  }

  void _scheduleReconnect() {
    if (_isReconnectScheduled) {
      log.fine('Reconnect is already scheduled. Ignoring this request.');
      return;
    }
    disconnect();
    _isReconnectScheduled = true;
    const delay = Duration(seconds: 1);
    log.info('Scheduling reconnect in ${delay.inSeconds} second(s)...');
    Future.delayed(delay, () {
      _isReconnectScheduled = false;
      _connect();
    });
  }

  Future<int> send(TmsCommand command) async {
    if (TmsCommand is TemperatureCommand) {
      targetTemperature = (command as TemperatureCommand).targetTemperature;
    }

    final serialPort = _serialPort;
    if (serialPort == null || !serialPort.isOpen) {
      log.warning('Serial port is either null or not open.');
      throw StateError('Serial port is either null or not open.');
    }

    Uint8List bytes =
        Uint8List.fromList(utf8.encode(jsonEncode(command.toJson())));
    log.fine('Sending command to the device.');
    try {
      return serialPort.write(bytes, timeout: sendTimeout.inMilliseconds);
    } on SerialPortError catch (e) {
      log.severe('Serial port error on send: $e');
      rethrow;
    }
  }

  void reset() {
    _tmsResetLine.setValue(false); // toggle GPIO
    Future.delayed(const Duration(milliseconds: 100), () {
      _tmsResetLine.setValue(true); // toggle GPIO
    });
  }

  void disconnect() {
    _isConnected = false;
    targetTemperature = 0; // reset to 0 on disconnect
    notifyListeners();
    if (_serialPortReader != null) {
      log.fine('Closing serial port reader.');
      _serialPortReader!.close();
      _serialPortReader = null;
    }

    final serialPort = _serialPort;
    if (serialPort != null) {
      if (serialPort.isOpen) {
        log.info('Closing serial port.');
        serialPort.close();
      }
      log.info('Disposing serial port.');
      serialPort.dispose();
      _serialPort = null;
    }
  }

  void runProfile(ReflowProfile profile) {
    if (isProfileRunning) {
      log.warning('Attempted to run a profile while one is already running.');
      return;
    }
    log.info('Running profile: ${profile.name}');
    _profileTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (profile.duration.inMilliseconds < timer.tick * 500) {
        log.info('Profile complete.');
        timer.cancel();
        _profileTimer = null;
        return;
      }
      final temperature = profile.getTemperature(Duration(
          milliseconds:
              timer.tick * 500)); // get temperature for current profile time
      log.finest('Sending target temperature to TMS: $temperature');
      // send(TemperatureCommand(temperature));
      _targetTemperature = temperature;
      notifyListeners();
    });
  }

  void stopProfile() {
    if (isProfileRunning) {
      _profileTimer?.cancel();
      send(TemperatureCommand(0));
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter_reflow/models/tms_status.dart';
import 'package:flutter_reflow/models/tms_log.dart';

import 'package:libserialport/libserialport.dart';

const sendTimeout = Duration(milliseconds: 100);

class TmsService {
  // TODO we should probably use one of those fancy new dart finalizers to make sure we clean up after ourselves

  SerialPort? _serialPort;
  SerialPortReader? _serialPortReader;

  final StreamController<TmsStatus> _statusStreamController = StreamController();
  final StreamController<TmsLog> _logStreamController = StreamController();

  Stream<TmsStatus> get statusStream => _statusStreamController.stream;
  Stream<TmsLog> get logStream => _logStreamController.stream;

  TmsService() {
    connect();
  }

  // factory TmsService.connect() {
  //   // TODO: huh, maybe we should use a factory
  // }

  // really we should be raising exceptions or something
  connect() {
    _serialPort!.dispose();
    SerialPort.availablePorts.first;

    if (SerialPort.availablePorts.isEmpty) {
      // TODO implement logging library
      print('No serial ports found!');
      return;
    }

    _serialPort = SerialPort(SerialPort.availablePorts.first);

    if (!_serialPort!.openReadWrite()) {
      // TODO implement logging library
      print('Failed to open serial port!');
      return;
    }

    _serialPort!.config.baudRate = 115200;
    _serialPort!.config.parity = 0;
    _serialPort!.config.bits = 8;
    _serialPort!.config.stopBits = 1;
    _serialPort!.config.xonXoff = 0;
    _serialPort!.config.setFlowControl(0);
    _serialPort!.config.dtr = 0;
    _serialPort!.config.rts = 0;

    _serialPortReader = SerialPortReader(_serialPort!);
    // _serialPortReader!.stream;

    // listen for data on serial port, decode and add to respective stream
    _serialPortReader!.stream.listen((data) {
      // decode data to string
      var json = jsonDecode(utf8.decode(data));
      // check if json contains key 'severity'
      if (json.containsKey('state')) {
        _statusStreamController.add(TmsStatus.fromJson(json));
      } else if (json.containsKey('severity')) {
        _logStreamController.add(TmsLog.fromJson(json));
      }
    }, onError: (error) {
      // TODO implement logging library
      print('Error: $error');
    }, onDone: () {
      // TODO need to somehow handle this reconnecting
      print('Done!');
      _serialPortReader!.close();
      _serialPort!.dispose();
    });
  }

  Future<int> send(String data) async {
    // TODO need to check if serial port is even valid
    // encode data to uint8list
    Uint8List bytes = utf8.encode(data) as Uint8List;
    try {
      return _serialPort!.write(bytes, timeout: sendTimeout.inMilliseconds);
    } on SerialPortError catch (e) {
      print(e); // TODO... here as well
    }
    return 0;
  }

  void disconnect() {
    _serialPortReader?.close();
    _serialPort?.dispose();
  }
}

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

  // stream of tms status
  Stream<TmsStatus> get statusStream async* {
    // TODO make sure we don't need to do anything funky like combine chunks to make sure we get a full json object
    await for (var data in _serialPortReader!.stream) {
      // decode data to string
      var json = jsonDecode(utf8.decode(data));
      // check if json contains key 'severity'
      if (json.containsKey('state')) {
        yield TmsStatus.fromJson(json);
      }
    }
  }

  Stream<TmsLog> get logStream async* {
    // TODO make sure we don't need to do anything funky like combine chunks to make sure we get a full json object
    await for (var data in _serialPortReader!.stream) {
      // decode data to string
      var json = jsonDecode(utf8.decode(data));
      // check if json contains key 'severity'
      if (json.containsKey('severity')) {
        yield TmsLog.fromJson(json);
      }
    }
  }

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

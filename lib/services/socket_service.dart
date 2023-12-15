import 'dart:async';
import 'package:flutter_reflow/models/oven_status.dart';
import 'package:flutter_reflow/models/reflow_status.dart';
import 'package:flutter_reflow/models/log_message.dart';
import 'package:logging/logging.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final log = Logger('socket');

class SocketService {
  final IO.Socket socket;
  final StreamController<OvenStatus> _ovenStatusController = StreamController<OvenStatus>.broadcast();
  final StreamController<ReflowStatus> _reflowStatusController = StreamController<ReflowStatus>.broadcast();
  final StreamController<LogMessage> _logMessageController = StreamController<LogMessage>.broadcast();

  SocketService(this.socket) {
    socket.connect();
    socket.on('connect', (_) => log.fine('connected'));
    socket.on('disconnect', (_) => log.fine('disconnected'));
    // print all messages from the server
    socket.on('message', (data) => log.finest(data));
    socket.on('oven_status', (data) => _ovenStatusController.add(OvenStatus.fromJson(data)));
    socket.on('reflow_status', (data) => _reflowStatusController.add(ReflowStatus.fromJson(data)));
    socket.on('log_message', (data) => _logMessageController.add(LogMessage.fromJson(data)));
  }

  Stream<OvenStatus> get ovenStatusStream => _ovenStatusController.stream;
  Stream<ReflowStatus> get reflowStatusStream => _reflowStatusController.stream;
  Stream<LogMessage> get logMessageStream => _logMessageController.stream;

  void dispose() {
    _ovenStatusController.close();
    _reflowStatusController.close();
    _logMessageController.close();
  }
}

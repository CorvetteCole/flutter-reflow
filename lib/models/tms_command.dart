import 'package:flutter_reflow/models/tms_log.dart';

abstract class TmsCommand {

  Map<String, dynamic> toJson();

}

class TemperatureCommand implements TmsCommand {
  final int targetTemperature;

  TemperatureCommand(this.targetTemperature);

  @override
  Map<String, dynamic> toJson() {
    return {'targetTemperature': targetTemperature};
  }
}

class LogLevelCommand implements TmsCommand {
  final TmsLogSeverity severity;

  LogLevelCommand(this.severity);

  @override
  Map<String, dynamic> toJson() {
    return {'severity': severity.name};
  }
}

// pid command, ki, kp, kd, and either top or bottom heating element
class PidCommand implements TmsCommand {
  final double kp;
  final double ki;
  final double kd;
  final bool top;

  PidCommand(this.kp, this.ki, this.kd, this.top);

  @override
  Map<String, dynamic> toJson() {
    return {
      'kp': kp,
      'ki': ki,
      'kd': kd,
      'top': top,
    };
  }
}

import 'package:flutter_reflow/models/tms_log.dart';

class TmsCommand {
  final int? targetTemperature;
  final TmsLogSeverity? severity;

  TmsCommand({this.targetTemperature, this.severity});

  // toJson but don't include null values
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    if (targetTemperature != null) {
      json['targetTemperature'] = targetTemperature!;
    }
    if (severity != null) {
      json['severity'] = severity!.name;
    }
    return json;
  }
}

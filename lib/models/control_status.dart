import 'package:json_annotation/json_annotation.dart';
import 'reflow_curve.dart';
import 'reflow_status.dart';

part 'control_status.g.dart';

@JsonSerializable()
class ControlStatus {
  final ReflowCurve curve;
  final ReflowStatus reflow;

  ControlStatus({
    required this.curve,
    required this.reflow,
  });

  factory ControlStatus.fromJson(Map<String, dynamic> json) => _$ControlStatusFromJson(json);
  Map<String, dynamic> toJson() => _$ControlStatusToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'reflow_curve.dart';

part 'reflow_status.g.dart';

enum ControlState {
  @JsonValue(0)
  idle,
  @JsonValue(1)
  preparing,
  @JsonValue(2)
  running,
  @JsonValue(3)
  complete,
  @JsonValue(4)
  cancelled,
  @JsonValue(5)
  fault
}

@JsonSerializable()
class ReflowStatus {
  @JsonKey(name: 'actual_temperatures')
  final ReflowCurve? actualTemperatures;

  @JsonKey(unknownEnumValue: ControlState.idle)
  final ControlState state;
  final String? error;

  ReflowStatus({
    required this.actualTemperatures,
    required this.state,
    this.error,
  });

  factory ReflowStatus.fromJson(Map<String, dynamic> json) =>
      _$ReflowStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ReflowStatusToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'oven_status.g.dart';

enum OvenState {
  @JsonValue(0)
  idle,
  @JsonValue(1)
  heating,
  @JsonValue(2)
  cooling,
  @JsonValue(3)
  fault
}

@JsonSerializable()
class OvenStatus {
  final int time;
  final double temperature;

  @JsonKey(unknownEnumValue: OvenState.idle)
  final OvenState state;
  @JsonKey(name: 'duty_cycle')
  final int dutyCycle;
  @JsonKey(name: 'door_open')
  final bool doorOpen;
  final List<String>? errors;

  OvenStatus({
    required this.time,
    required this.temperature,
    required this.state,
    required this.dutyCycle,
    required this.doorOpen,
    this.errors,
  });

  factory OvenStatus.fromJson(Map<String, dynamic> json) =>
      _$OvenStatusFromJson(json);

  Map<String, dynamic> toJson() => _$OvenStatusToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflow_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReflowStatus _$ReflowStatusFromJson(Map<String, dynamic> json) => ReflowStatus(
      actualTemperatures: json['actual_temperatures'] == null
          ? null
          : ReflowCurve.fromJson(
              json['actual_temperatures'] as Map<String, dynamic>),
      state: $enumDecode(_$ControlStateEnumMap, json['state'],
          unknownValue: ControlState.idle),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ReflowStatusToJson(ReflowStatus instance) =>
    <String, dynamic>{
      'actual_temperatures': instance.actualTemperatures,
      'state': _$ControlStateEnumMap[instance.state]!,
      'error': instance.error,
    };

const _$ControlStateEnumMap = {
  ControlState.idle: 0,
  ControlState.preparing: 1,
  ControlState.running: 2,
  ControlState.complete: 3,
  ControlState.cancelled: 4,
  ControlState.fault: 5,
};

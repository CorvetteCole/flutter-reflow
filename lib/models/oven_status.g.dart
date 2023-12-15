// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oven_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvenStatus _$OvenStatusFromJson(Map<String, dynamic> json) => OvenStatus(
      time: json['time'] as int,
      temperature: (json['temperature'] as num).toDouble(),
      state: $enumDecode(_$OvenStateEnumMap, json['state'],
          unknownValue: OvenState.idle),
      dutyCycle: json['duty_cycle'] as int,
      doorOpen: json['door_open'] as bool,
      errors:
          (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OvenStatusToJson(OvenStatus instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature': instance.temperature,
      'state': _$OvenStateEnumMap[instance.state]!,
      'duty_cycle': instance.dutyCycle,
      'door_open': instance.doorOpen,
      'errors': instance.errors,
    };

const _$OvenStateEnumMap = {
  OvenState.idle: 0,
  OvenState.heating: 1,
  OvenState.cooling: 2,
  OvenState.fault: 3,
};

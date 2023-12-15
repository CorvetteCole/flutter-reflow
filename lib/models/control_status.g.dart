// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'control_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ControlStatus _$ControlStatusFromJson(Map<String, dynamic> json) =>
    ControlStatus(
      curve: ReflowCurve.fromJson(json['curve'] as Map<String, dynamic>),
      reflow: ReflowStatus.fromJson(json['reflow'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ControlStatusToJson(ControlStatus instance) =>
    <String, dynamic>{
      'curve': instance.curve,
      'reflow': instance.reflow,
    };

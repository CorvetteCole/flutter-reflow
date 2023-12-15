// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflow_curve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReflowCurve _$ReflowCurveFromJson(Map<String, dynamic> json) => ReflowCurve(
      name: json['name'] as String?,
      description: json['description'] as String?,
      times: (json['times'] as List<dynamic>).map((e) => e as int).toList(),
      temperatures: (json['temperatures'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$ReflowCurveToJson(ReflowCurve instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'times': instance.times,
      'temperatures': instance.temperatures,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogMessage _$LogMessageFromJson(Map<String, dynamic> json) => LogMessage(
      message: json['message'] as String,
      severity: $enumDecode(_$LogSeverityEnumMap, json['severity'],
          unknownValue: LogSeverity.debug),
      time: json['time'] as int,
    );

Map<String, dynamic> _$LogMessageToJson(LogMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'severity': _$LogSeverityEnumMap[instance.severity]!,
      'time': instance.time,
    };

const _$LogSeverityEnumMap = {
  LogSeverity.debug: 0,
  LogSeverity.info: 1,
  LogSeverity.warn: 2,
  LogSeverity.critical: 3,
};

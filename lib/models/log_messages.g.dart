// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogMessages _$LogMessagesFromJson(Map<String, dynamic> json) => LogMessages(
      logs: (json['logs'] as List<dynamic>)
          .map((e) => LogMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LogMessagesToJson(LogMessages instance) =>
    <String, dynamic>{
      'logs': instance.logs,
    };

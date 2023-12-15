import 'package:json_annotation/json_annotation.dart';
import 'log_message.dart';

part 'log_messages.g.dart';

@JsonSerializable()
class LogMessages {
  final List<LogMessage> logs;

  LogMessages({required this.logs});

  factory LogMessages.fromJson(Map<String, dynamic> json) => _$LogMessagesFromJson(json);
  Map<String, dynamic> toJson() => _$LogMessagesToJson(this);
}

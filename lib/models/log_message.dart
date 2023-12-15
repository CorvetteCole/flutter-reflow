import 'package:json_annotation/json_annotation.dart';

part 'log_message.g.dart';

enum LogSeverity {
  @JsonValue(0)
  debug,
  @JsonValue(1)
  info,
  @JsonValue(2)
  warn,
  @JsonValue(3)
  critical
}

@JsonSerializable()
class LogMessage {
  final String message;

  @JsonKey(unknownEnumValue: LogSeverity.debug)
  final LogSeverity severity;
  final int time;

  LogMessage({
    required this.message,
    required this.severity,
    required this.time,
  });

  factory LogMessage.fromJson(Map<String, dynamic> json) =>
      _$LogMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LogMessageToJson(this);
}

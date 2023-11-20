enum TmsLogSeverity { debug, info, warn, critical, unknown }

class TmsLog {
  final Duration time;
  final TmsLogSeverity severity;
  final String message;

  TmsLog(this.time, this.severity, this.message);

  TmsLog.unknown()
      : time = Duration.zero,
        severity = TmsLogSeverity.unknown,
        message = '';

  TmsLog.fromJson(Map<String, dynamic> json)
      : time = Duration(milliseconds: json['time']),
        severity = TmsLogSeverity.values.firstWhere(
            (e) => e.name.toLowerCase() == json['severity'],
            orElse: () => TmsLogSeverity.unknown),
        message = json['message'];

  @override
  String toString() {
    return 'TmsLog{time: $time, severity: $severity, message: $message}';
  }
}

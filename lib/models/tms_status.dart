enum TmsState { idle, heating, cooling, error, unknown }

enum TmsError {
  none,
  doorOpenedDuringHeating,
  targetTemperatureTooLow,
  targetTemperatureTooHigh,
  currentTemperatureTooLow,
  currentTemperatureTooHigh,
  uiTimeout,
  currentTemperatureRoseTooQuickly,
  currentTemperatureFellTooQuickly,
  unknown
}

class TmsStatus {
  final int targetTemperature;
  final int currentTemperature;
  final TmsState state;
  final TmsError error;

  TmsStatus({
    required this.targetTemperature,
    required this.currentTemperature,
    required this.state,
    required this.error,
  });

  TmsStatus.fromJson(Map<String, dynamic> json)
      : targetTemperature = json['targetTemperature'],
        currentTemperature = json['currentTemperature'],
        state = TmsState.values.firstWhere((e) => e.name == json['state'],
            orElse: () => TmsState.unknown),
        error = json['error']
            ? TmsError.values.firstWhere((e) => e.name == json['error'],
                orElse: () => TmsError.unknown)
            : TmsError.none;
}

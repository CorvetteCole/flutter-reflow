enum TmsState { idle, heating, cooling, error, unknown }

enum TmsError {
  none('No error'),
  doorOpenedDuringHeating('Door opened during heating'),
  targetTemperatureTooLow('Target temperature too low'),
  targetTemperatureTooHigh('Target temperature too high'),
  currentTemperatureTooLow('Current temperature too low'),
  currentTemperatureTooHigh('Current temperature too high'),
  currentTemperatureRoseTooQuickly('Current temperature rose too quickly'),
  currentTemperatureFellTooQuickly('Current temperature fell too quickly'),
  uiTimeout('UI timeout'),
  unknown('Unknown error');

  final String friendlyMessage;

  const TmsError(this.friendlyMessage);
}

class TmsStatus {
  final DateTime lastUpdated = DateTime.now();
  final int targetTemperature;
  final int currentTemperature;
  final TmsState state;
  final TmsError error;
  final bool isDoorOpen;

  TmsStatus({
    required this.targetTemperature,
    required this.currentTemperature,
    required this.state,
    required this.error,
    required this.isDoorOpen,
  });

  TmsStatus.fromJson(Map<String, dynamic> json)
      : targetTemperature = json['targetTemperature'],
        currentTemperature = json['currentTemperature'],
        state = TmsState.values.firstWhere((e) => e.name == json['state'],
            orElse: () => TmsState.unknown),
        error = json['error']
            ? TmsError.values.firstWhere((e) => e.name == json['error'],
                orElse: () => TmsError.unknown)
            : TmsError.none,
        isDoorOpen = json['door_open'];
}

enum TmsState { idle, heating, cooling, error, unknown }

// enum TmsError {
//   none,
//   doorOpenedDuringHeating,
//   targetTemperatureTooLow,
//   targetTemperatureTooHigh,
//   currentTemperatureTooLow,
//   currentTemperatureTooHigh,
//   uiTimeout,
//   currentTemperatureRoseTooQuickly,
//   currentTemperatureFellTooQuickly,
//   unknown
// }

enum TmsError implements Comparable<TmsError> {
  none(friendlyMessage: 'No error'),
  doorOpenedDuringHeating(friendlyMessage: 'Door opened during heating'),
  targetTemperatureTooLow(friendlyMessage: 'Target temperature too low'),
  targetTemperatureTooHigh(friendlyMessage: 'Target temperature too high'),
  currentTemperatureTooLow(friendlyMessage: 'Current temperature too low'),
  currentTemperatureTooHigh(friendlyMessage: 'Current temperature too high'),
  currentTemperatureRoseTooQuickly(friendlyMessage: 'Current temperature rose too quickly'),
  currentTemperatureFellTooQuickly(friendlyMessage: 'Current temperature fell too quickly'),
  uiTimeout(friendlyMessage: 'UI timeout'),
  unknown(friendlyMessage: 'Unknown error');

  final String friendlyMessage;
  const TmsError({required this.friendlyMessage});
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

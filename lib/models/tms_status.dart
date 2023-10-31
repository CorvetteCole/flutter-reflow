enum TmsState { idle, heating, cooling, fault, unknown }

enum TmsError {
  doorOpenedDuringHeating('Door opened during heating', 0x01),
  targetTemperatureTooLow('Target temperature too low', 0x02),
  targetTemperatureTooHigh('Target temperature too high', 0x04),
  currentTemperatureTooLow('Current temperature too low', 0x08),
  currentTemperatureTooHigh('Current temperature too high', 0x10),
  currentTemperatureNotRisingDuringHeating(
      'Current temperature not rising during heating', 0x20),
  currentTemperatureFault('Fault while reading current temperature', 0x40),
  uiTimeout('UI timeout', 0x80);

  final String friendlyMessage;
  final int code;

  const TmsError(this.friendlyMessage, this.code);
}

class TmsStatus {
  final DateTime lastUpdated = DateTime.now();
  final int targetTemperature;
  final int currentTemperature;
  final int topHeatDutyCycle;
  final int bottomHeatDutyCycle;
  final TmsState state;
  final int _error;
  final bool isDoorOpen;

  List<TmsError> get errors {
    return TmsError.values.where((e) => _error & e.code != 0).toList();
  }

  bool get hasErrors => _error != 0;

  TmsStatus(
      this.targetTemperature,
      this.currentTemperature,
      this.topHeatDutyCycle,
      this.bottomHeatDutyCycle,
      this.isDoorOpen,
      this._error,
      this.state);

  TmsStatus.fromJson(Map<String, dynamic> json)
      : targetTemperature = json['targetTemperature'],
        currentTemperature = json['currentTemperature'],
        topHeatDutyCycle = json['topHeatDutyCycle'],
        bottomHeatDutyCycle = json['bottomHeatDutyCycle'],
        isDoorOpen = json['isDoorOpen'],
        _error = json['error'],
        state = TmsState.values.firstWhere((e) => e.name == json['state'],
            orElse: () => TmsState.unknown);
}

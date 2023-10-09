enum OvenStatus { idle, heating, cooling, error }

class OvenState {
  final double currentTemperature;
  final double targetTemperature;

  OvenStatus status;

  /// Does not exist if the status is not error
  String? errorMessage;

  OvenState(
      {required this.currentTemperature,
      required this.targetTemperature,
      required this.status,
      this.errorMessage});
}

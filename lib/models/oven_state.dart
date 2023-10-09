import 'package:flutter_reflow/models/tms_status.dart';

enum OvenStatus { idle, heating, cooling, error }

// need to catch non-TMS error of accrued difference between target and current
// temperature becoming too large
enum OvenErrorType { none, tms, temperatureDifference }

class OvenState {
  final int currentTemperature;
  final int targetTemperature;
  final List<int> currentCurve;

  OvenStatus status;
  TmsStatus tmsStatus;

  OvenState(
      {required this.currentTemperature,
      required this.targetTemperature,
      required this.status,
      required this.tmsStatus});
}

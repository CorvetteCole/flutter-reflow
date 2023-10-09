import 'package:flutter_reflow/models/tms_status.dart';
import 'package:flutter_reflow/models/heat_curve.dart';

enum OvenState { idle, heating, cooling, error }

// need to catch non-TMS error of accrued difference between target and current
// temperature becoming too large
enum OvenErrorType { none, tms, temperatureDifference }

class OvenStatus {
  final int currentTemperature;
  final HeatCurve? currentCurve;

  final OvenState state;
  final TmsStatus tmsStatus;

  OvenStatus(
      {required this.currentTemperature,
      required this.state,
      required this.tmsStatus,
      this.currentCurve});
}

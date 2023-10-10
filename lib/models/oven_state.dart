import 'package:flutter_reflow/models/tms_status.dart';
import 'package:flutter_reflow/models/heat_curve.dart';

enum OvenState { idle, heating, cooling, error }

// need to catch non-TMS error of accrued difference between target and current
// temperature becoming too large
enum OvenErrorType { none, tms, temperatureDifference }

class OvenStatus {
  final int temperature;
  final HeatCurve? curve;

  final OvenState state;
  final TmsStatus tmsStatus;

  OvenStatus(
      {required this.temperature,
      required this.state,
      required this.tmsStatus,
      this.curve});
}

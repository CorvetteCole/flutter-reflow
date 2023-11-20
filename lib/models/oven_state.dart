import 'package:flutter_reflow/models/tms/tms_status.dart';
import 'package:flutter_reflow/models/heat_curve.dart';

enum OvenState { idle, running, error }

// need to catch non-TMS error of accrued difference between target and current
// temperature becoming too large
enum OvenErrorType { none, tms, local }

class OvenStatus {
  final HeatCurve? curve;

  final OvenState state;
  final TmsStatus tmsStatus;

  OvenStatus(
      {required this.state,
      required this.tmsStatus,
      this.curve});

  num get currentTemperature => tmsStatus.currentTemperature;
  num get targetTemperature => curve?.targetTemperature ?? tmsStatus.targetTemperature;

}

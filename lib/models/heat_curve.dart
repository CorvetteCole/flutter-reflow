class HeatCurve {
  // a curve for reflow oven soldering. Different temperatures need to be reached at different times

  int maxTemperatureDifference = 1;
  Duration maxTimeDifference = const Duration(seconds: 5);

  double maxError = 0.3;
  double maxErrorPerPoint = 0.05;
  double totalTimeErrorWeight = 0.5;
  double temperatureErrorWeight = 0.5;
  double singlePointTimeErrorWeight = 0.5;

  DateTime started = DateTime.now();

  double currentIndexStartError = 0;
  DateTime currentIndexStarted = DateTime.now();
  int currentIndex = 0;
  double accruedError = 0;

  final Map<int, Duration> curve;
  late final Duration curveDuration;

  HeatCurve(this.curve) {
    curveDuration = curve.values.reduce((value, element) => value + element);
  }

  void _iterateCurve() {
    if (currentIndex < curve.length - 1) {
      currentIndex++;
      currentIndexStarted = DateTime.now();
    } else {
      throw RangeError('Curve is already at the end');
    }
  }

  void _calculateError(int currentTemperature) {
    if (currentIndexStarted.difference(DateTime.now()) > targetDuration) {
      // weight timeDifference by the total duration of the curve
      double singleTimeError =
          (currentIndexStarted.difference(DateTime.now()) - targetDuration)
                  .inMilliseconds /
              curveDuration.inMilliseconds;
      double temperatureError =
          (targetTemperature - currentTemperature).abs() / 100;

      accruedError += singleTimeError * singlePointTimeErrorWeight +
          temperatureError * temperatureErrorWeight;
    }

    if (started.difference(DateTime.now()) > curveDuration) {
      double totalTimeError =
          started.difference(DateTime.now()).inMilliseconds /
              curveDuration.inMilliseconds;
      accruedError += totalTimeError * totalTimeErrorWeight;
    }
  }

  void calculateTarget(int currentTemperature) {
    // TODO consider the following:
    // - what do we do if we hit the target before the desired time?
    // - should we interpolate between points?
    // - current algorithm punishes segments after the total curve duration more
    // than segments before it (good?)
    // - _calculateError is not temporally stable. The more you call it, the
    // faster error will accrue. Maybe we should internally track error
    // per-point to make decisions on whether to move on and only update the
    // accrued error when we move on to the next point?
    // - per point time error is weighted less if the point is a small part of
    // the curve, but this may not be desirable
    // - do we want to move on at all if the temperature is not where we want
    // it? That puts following segments at risk of not being reached either
    if (targetTemperature - currentTemperature == 0 ||
        currentIndexStartError > maxErrorPerPoint) {
      _iterateCurve();
    }

    _calculateError(currentTemperature);
  }

  bool get isFinished {
    return currentIndex == curve.length - 1;
  }

  bool get isFailed {
    return accruedError > maxError;
  }

  int get targetTemperature {
    return curve.keys.elementAt(currentIndex);
  }

  Duration get targetDuration {
    return curve.values.elementAt(currentIndex);
  }
}

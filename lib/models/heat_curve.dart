class HeatCurve {
  // a curve for reflow oven soldering. Different temperatures need to be reached at different times

  int maxTemperatureDifference = 1;
  Duration maxTimeDifference = const Duration(seconds: 5);

  double maxError = 0.3;
  double maxErrorPerPoint = 0.05;
  double totalTimeErrorWeight = 0.5;
  double temperatureErrorWeight = 0.5;
  double singlePointTimeErrorWeight = 0.5;

  // needs:
  // - list of temperatures and times, relative to the start of this curve
  // - current target temperature (and time)

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
    if (targetTemperature - currentTemperature == 0 ||
        currentIndexStartError > maxErrorPerPoint) {
      _iterateCurve();
    }

    _calculateError(currentTemperature);
  }

  int get targetTemperature {
    return curve.keys.elementAt(currentIndex);
  }

  Duration get targetDuration {
    return curve.values.elementAt(currentIndex);
  }
}

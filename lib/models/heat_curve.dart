import 'dart:collection';
import 'dart:math';

class Point {
  /// The temperature to reach at this point
  final int temperature;

  /// The duration from the start of the curve to this point
  final Duration duration;

  bool _isComplete = false;

  Point(this.temperature, this.duration);

  /// Whether the point has been completed.
  bool get isComplete => _isComplete;

  /// Mark the point as complete.
  ///
  /// This cannot be undone.
  void complete() {
    _isComplete = true;
  }

  /// Calculate the error for this point from an actual temperature and duration.
  ///
  /// The error is a double between 0 and 1, where 0 is no error and 1 is the
  /// maximum error.
  double calculateError(int actualTemperature, Duration actualDuration) {
    // TODO can weight error to prefer temperature or time
    double temperatureError = (temperature - actualTemperature).abs() / 100;
    double timeError =
        (duration - actualDuration).inMilliseconds / duration.inMilliseconds;

    return temperatureError + timeError;
  }
}

class Curve {
  final List<Point> _points;

  // empty iterator to start
  Iterator<Point> _currentPoint = const Iterable<Point>.empty().iterator;
  DateTime? _started;
  DateTime? _finished;
  bool _isFinished = false;

  Curve(this._points) {
    // check if points are ordered by duration to form a valid curve, throw error if not
    for (var i = 0; i < _points.length - 1; i++) {
      if (_points.elementAt(i).duration > _points.elementAt(i + 1).duration) {
        throw ArgumentError('Points are not ordered by duration');
      }
    }
  }

  void start() {
    _currentPoint = _points.iterator;
    _started = DateTime.now();
  }

  DateTime? get started => _started;

  Duration get duration => _points.last.duration;

  Duration get finalDuration => _finished!.difference(_started!);

  bool get isFinished => _isFinished;

  UnmodifiableListView<Point> get points => UnmodifiableListView(_points);

  /// Get the current point in the curve.
  Point get currentPoint => _currentPoint.current;

  /// Advance to the next point in the curve.
  bool advance() {
    _currentPoint.current.complete();
    bool moveNext = _currentPoint.moveNext();
    if (!moveNext) {
      // TODO do any other completion tasks
      _finished = DateTime.now();
      _isFinished = true;
    }
    return moveNext;
  }
}

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

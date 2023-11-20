import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class ReflowProfilePoint {
  final Duration time;
  final int temperature;

  ReflowProfilePoint(this.time, this.temperature);
}

class ReflowProfile extends ChangeNotifier {
  final String name;
  final String model;
  final String manufacturer;

  final List<ReflowProfilePoint> _points;

  ReflowProfile(this.name, this.model, this.manufacturer, this._points) {
    // check if points are ordered by duration to form a valid curve, throw error if not
    for (var i = 0; i < _points.length - 1; i++) {
      if (_points.elementAt(i).time > _points.elementAt(i + 1).time) {
        throw ArgumentError('Points are not ordered by duration');
      }
    }
  }

  UnmodifiableListView<ReflowProfilePoint> get points =>
      UnmodifiableListView(_points);

  Duration get duration => _points.last.time;

  int getTemperature(Duration currentTime) {
// if the current time is before the first point, return the first point's temperature
    if (currentTime < _points.first.time) {
      return _points.first.temperature;
    }
    // if the current time is after the last point, return the last point's temperature
    if (currentTime > _points.last.time) {
      return _points.last.temperature;
    }
    // otherwise, find the two points that the current time is between and interpolate
    for (var i = 0; i < _points.length - 1; i++) {
      if (_points.elementAt(i).time <= currentTime &&
          _points.elementAt(i + 1).time >= currentTime) {
        final x1 = _points.elementAt(i).time.inSeconds;
        final x2 = _points.elementAt(i + 1).time.inSeconds;
        final y1 = _points.elementAt(i).temperature;
        final y2 = _points.elementAt(i + 1).temperature;
        final x = currentTime.inSeconds;
        final y = ((y2 - y1) / (x2 - x1)) * (x - x1) + y1;
        return y.round();
      }
    }
    throw StateError('Could not find temperature for time $currentTime');
  }

  int get highestTemperature => _points
      .map((e) => e.temperature)
      .reduce((value, element) => value > element ? value : element);

  set name(String newName) {
    name = newName;
    notifyListeners();
  }

  set model(String newModel) {
    model = newModel;
    notifyListeners();
  }

  set manufacturer(String newManufacturer) {
    manufacturer = newManufacturer;
    notifyListeners();
  }

  set points(List<ReflowProfilePoint> newPoints) {
    _points.clear();
    _points.addAll(newPoints);
    notifyListeners();
  }

  ReflowProfile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        model = json['model'],
        manufacturer = json['manufacturer'],
        _points = (json['points'] as List<dynamic>)
            .map((e) =>
                ReflowProfilePoint(Duration(seconds: e[0] as int), e[1] as int))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model,
        'manufacturer': manufacturer,
        'points':
            _points.map((e) => [e.time.inSeconds, e.temperature]).toList(),
      };
}

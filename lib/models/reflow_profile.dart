import 'dart:collection';

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
        _points = (json['points'] as List<List<int>>)
            .map((e) => ReflowProfilePoint(Duration(seconds: e[0]), e[1]))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'model': model,
        'manufacturer': manufacturer,
        'points':
            _points.map((e) => [e.time.inSeconds, e.temperature]).toList(),
      };
}
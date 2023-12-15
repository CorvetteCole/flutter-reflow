import 'package:json_annotation/json_annotation.dart';

part 'reflow_curve.g.dart';

@JsonSerializable()
class ReflowCurve {
  final String? name;
  final String? description;
  final List<int> times;
  final List<double> temperatures;

  ReflowCurve({
    this.name,
    this.description,
    required this.times,
    required this.temperatures,
  });

  factory ReflowCurve.fromJson(Map<String, dynamic> json) =>
      _$ReflowCurveFromJson(json);

  Map<String, dynamic> toJson() => _$ReflowCurveToJson(this);

  double get maxTemperature => temperatures.reduce((a, b) => a > b ? a : b);

  Duration get duration => Duration(seconds: times.last);
}

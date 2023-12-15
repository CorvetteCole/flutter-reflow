import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/screens/status_screen.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

final leadedCurve = ReflowCurve(
  name: "Leaded",
  description: "Chip Quik© SMD4300AX10",
  times: [0, 30, 120, 150, 210, 240],
  temperatures: [25, 100, 150, 183, 235, 183],
);

final unleadedCurve = ReflowCurve(
  name: "Unleaded",
  description: "Chip Quik© TS391LT",
  times: [0, 90, 180, 210, 240, 270],
  temperatures: [35, 90, 130, 138, 165, 138],
);

class CurveSelectPage extends StatelessWidget {
  CurveSelectPage({Key? key}) : super(key: key);

  final List<ReflowCurve> curves = [unleadedCurve, leadedCurve];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: curves.length,
        itemBuilder: (context, index) {
          return CurveCard(
            curves[index],
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurveDetailsScreen(curves[index])));
            },
          );
        });
  }
}

class CurveDetailsScreen extends StatelessWidget {
  final ReflowCurve curve;

  const CurveDetailsScreen(this.curve, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Profile'),
      ),
      body: Card(
          margin: const EdgeInsets.all(10),
          child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      curve.name!,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      curve.description!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 195,
                      child: SfCartesianChart(
                        primaryXAxis: NumericAxis(
                          title: AxisTitle(text: 'Time (seconds)'),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Temperature (°C)'),
                        ),
                        series: <ChartSeries>[
                          LineSeries<MapEntry<int, double>, int>(
                            dataSource: List<MapEntry<int, double>>.generate(
                              curve.times.length,
                              (index) => MapEntry(curve.times[index],
                                  curve.temperatures[index]),
                            ),
                            xValueMapper: (MapEntry<int, double> entry, _) =>
                                entry.key,
                            yValueMapper: (MapEntry<int, double> entry, _) =>
                                entry.value,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Max temperature:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${curve.maxTemperature}°C',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Approximate time:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${curve.duration.inSeconds} seconds',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed: () => {
                              context.read<ApiService>().startCurve(curve),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StatusScreen(targetCurve: curve)))
                            },
                        style: FilledButton.styleFrom(
                          // foregroundColor: Colors.white,
                          // backgroundColor: Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(268, 40),
                        ),
                        child: const Text('Start')),
                  ]))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/oven_status.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/models/reflow_status.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatusScreen extends StatefulWidget {
  final ReflowCurve targetCurve;

  const StatusScreen({Key? key, required this.targetCurve}) : super(key: key);

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    final ovenStatus = Provider.of<OvenStatus>(context);
    final reflowStatus = Provider.of<ReflowStatus>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflow Status'),
      ),
      body: Column(
        children: [
          Expanded(
            child: reflowStatus.actualTemperatures != null
                ? SfCartesianChart(
                    primaryXAxis:
                        NumericAxis(title: AxisTitle(text: 'Time (seconds)')),
                    primaryYAxis:
                        NumericAxis(title: AxisTitle(text: 'Temperature (°C)')),
                    series: <ChartSeries>[
                      LineSeries<MapEntry<int, double>, int>(
                        name: 'Target Curve',
                        dataSource: List<MapEntry<int, double>>.generate(
                          widget.targetCurve.times.length,
                          (index) => MapEntry(widget.targetCurve.times[index],
                              widget.targetCurve.temperatures[index]),
                        ),
                        xValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.key,
                        yValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.value,
                      ),
                      LineSeries<MapEntry<int, double>, int>(
                        name: 'Actual Curve',
                        dataSource: List<MapEntry<int, double>>.generate(
                          reflowStatus.actualTemperatures!.times.length,
                          (index) => MapEntry(
                              reflowStatus.actualTemperatures!.times[index],
                              reflowStatus
                                  .actualTemperatures!.temperatures[index]),
                        ),
                        xValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.key,
                        yValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.value,
                      ),
                    ],
                  )
                : const Center(
                    child: Text('No actual temperature data available.')),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Temperature: ${ovenStatus.temperature}°C'),
                Text('Current State: ${ovenStatus.state}'),
                // Add more status information as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

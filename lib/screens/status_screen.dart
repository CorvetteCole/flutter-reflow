import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/oven_status.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/models/reflow_status.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/api_service.dart';
import 'error.dart';

class StatusScreen extends StatefulWidget {
  final ReflowCurve targetCurve;

  const StatusScreen({Key? key, required this.targetCurve}) : super(key: key);

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  void _cancelReflow() {
    context.read<ApiService>().stopCurve();
    Navigator.of(context).pop();
  }

  String _getPreparingMessage(OvenState ovenState) {
    switch (ovenState) {
      case OvenState.cooling:
        return 'Cooling down to 45C before starting the curve.';
      case OvenState.heating:
        return 'Preheating before starting the curve.';
      default:
        return 'Preparing...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ovenStatus = Provider.of<OvenStatus>(context);
    final reflowStatus = Provider.of<ReflowStatus>(context);

    if (ovenStatus.state == OvenState.fault) {
      return const ErrorScreen();
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Reflow Status'), automaticallyImplyLeading: false),
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
                : Center(
                    child: Text(
                        reflowStatus.state == ControlState.preparing
                            ? _getPreparingMessage(ovenStatus.state)
                            : 'Curve data not available yet.',
                        style: const TextStyle(fontSize: 20))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Temperature: ${ovenStatus.temperature.round()}°C'),
                Text('Current State: ${reflowStatus.state.name}'),
                // Add more status information as needed
                const SizedBox(height: 24), // Add space before the button
                ElevatedButton(
                  onPressed: () {
                    _cancelReflow();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 60), // make the button big
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20), // big text for the button
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

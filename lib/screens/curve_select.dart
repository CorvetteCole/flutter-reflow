import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_curve.dart';
import 'package:flutter_reflow/providers/curve_provider.dart';
import 'package:flutter_reflow/screens/status_screen.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/reflow_status.dart';

class CurveSelectPage extends StatefulWidget {
  const CurveSelectPage({Key? key}) : super(key: key);

  @override
  _CurveSelectPageState createState() => _CurveSelectPageState();
}

class _CurveSelectPageState extends State<CurveSelectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndNavigate());
  }

  void _checkAndNavigate() async {
    final controlStatus = await context.read<ApiService>().getCurveStatus();
    if (controlStatus.reflow.state == ControlState.running ||
        controlStatus.reflow.state == ControlState.preparing) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatusScreen(targetCurve: controlStatus.curve),
        ), // This condition prevents any route from being kept on the stack.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // The rest of the build method remains unchanged
    return Consumer<CurveProvider>(
      builder: (context, curveProvider, child) {
        // The rest of the builder method remains unchanged
        return RefreshIndicator(
            onRefresh: curveProvider.fetchCurves,
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: curveProvider.curves.length,
              itemBuilder: (context, index) {
                final curve = curveProvider.curves[index];
                return CurveCard(
                  curve,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CurveDetailsScreen(curve)));
                  },
                );
              },
            ));
      },
    );
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
              margin: const EdgeInsets.all(8),
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
                          minimumSize: const Size(268, 60),
                        ),
                        child: const Text('Start')),
                  ]))),
    );
  }
}

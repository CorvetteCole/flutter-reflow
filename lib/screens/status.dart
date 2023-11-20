import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_reflow/models/reflow_profile.dart';
import 'package:flutter_reflow/screens/error.dart';
import 'package:flutter_reflow/services/tms_service.dart';
import 'package:flutter_reflow/widgets/status_bar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/tms/tms_status.dart';

class StatusPage extends StatefulWidget {
  final ReflowProfile profile;

  const StatusPage(this.profile, {Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  DateTime? startTime;
  TmsService? _tmsService;
  Timer? _timer;

  List<ReflowProfilePoint> actualPoints = [];

  @override
  Widget build(BuildContext context) {
    final hasErrors = context.select((TmsStatus status) => status.hasErrors);
    final currentTemperature =
        context.select((TmsStatus status) => status.currentTemperature);

    _tmsService ??= context.read<TmsService>();
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tmsService!.targetTemperature == 0) {
        _tmsService!.targetTemperature = 35;
      } else if (currentTemperature >= 35) {
        startTime ??= DateTime.now();
        final currentDuration = startTime!.difference(DateTime.now());
        setState(() {
          actualPoints.add(
              ReflowProfilePoint(currentDuration, currentTemperature.round()));
        });
        if (currentDuration >= widget.profile.duration) {
          _timer!.cancel();
          _tmsService!.targetTemperature = 0;
          Navigator.pop(context);
        } else {
          // get current target temperature by interpolating between points on the profile based on duration. Skip through until we are past 35C
          final targetTemperature =
              widget.profile.getTemperature(currentDuration.inSeconds);
          _tmsService!.targetTemperature = targetTemperature;
        }
      }
    });

    // widget.profile
    return Scaffold(
      appBar: StatusBar(),
      body: Center(
        child: hasErrors
            ? const ErrorScreen()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Heating'),
                  Text('Caution: Do not open the door'),
                  SizedBox(height: 10),
                  SfCartesianChart(
                    primaryXAxis: NumericAxis(),
                    primaryYAxis: NumericAxis(),
                    series: <ChartSeries>[
                      LineSeries<ReflowProfilePoint, int>(
                        dataSource: actualPoints,
                        xValueMapper: (ReflowProfilePoint point, _) =>
                            point.time.inSeconds,
                        yValueMapper: (ReflowProfilePoint point, _) =>
                            point.temperature,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: startTime != null
                        ? startTime!.difference(DateTime.now()).inSeconds /
                            widget.profile.duration.inSeconds
                        : 0,
                  ),
                  SizedBox(height: 10),
                  FilledButton(
                      onPressed: () => {
                            _timer!.cancel(),
                            _tmsService!.targetTemperature = 0,
                            Navigator.pop(context),
                          },
                      child: const Text('Stop')),
                ],
              ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/reflow_profile.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

final leadedProfile = ReflowProfile.fromJson(jsonDecode(
    r'{"name": "Leaded", "model":"SMD4300AX10", "manufacturer":"Chip Quik©", "points":[[0,25],[30,100],[120,150],[150,183],[210,235],[240,183]]}'));

final unleadedProfile = ReflowProfile.fromJson(jsonDecode(
    r'{"name": "Unleaded","model":"TS391LT","manufacturer":"Chip Quik©","points":[[0,25],[90,90],[180,130],[210,138],[240,165],[270,138]]}'));

class CurveSelectPage extends StatelessWidget {
  CurveSelectPage({Key? key}) : super(key: key);

  final List<ReflowProfile> profiles = [unleadedProfile, leadedProfile];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          return CurveCard(
            profiles[index],
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CurveDetailsScreen(profiles[index])));
            },
          );
        });
  }
}

class CurveDetailsScreen extends StatelessWidget {
  final ReflowProfile profile;

  const CurveDetailsScreen(this.profile, {Key? key}) : super(key: key);

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
                      profile.name,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      '${profile.manufacturer} ${profile.model}',
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
                          LineSeries<ReflowProfilePoint, int>(
                            dataSource: profile.points,
                            xValueMapper: (ReflowProfilePoint point, _) =>
                                point.time.inSeconds,
                            yValueMapper: (ReflowProfilePoint point, _) =>
                                point.temperature,
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
                          '${profile.highestTemperature}°C',
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
                          '${profile.duration.inSeconds} seconds',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed: () => debugPrint('pressed!'),
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

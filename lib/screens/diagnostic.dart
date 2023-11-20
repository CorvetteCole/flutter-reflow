import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/tms_status.dart';
import 'package:provider/provider.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TmsStatus>(builder: (context, TmsStatus status, child) {
        return Column(children: [
          Text('Current Temperature: ${status.currentTemperature}'),
          Text('Target Temperature: ${status.targetTemperature}'),
          Text('State ${status.state}'),
          Text('Top Heater Duty Cycle ${status.topHeatDutyCycle}'),
          Text('Bottom Heater Duty Cycle ${status.bottomHeatDutyCycle}'),
          Text('Door Open ${status.isDoorOpen}'),
          Text('Errors ${status.errors}'),
        ]);
      }),
    );
  }
}

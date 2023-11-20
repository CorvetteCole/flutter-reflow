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

  List<ReflowProfilePoint> actualPoints = [];

  @override
  Widget build(BuildContext context) {
    final hasErrors = context.select((TmsStatus status) => status.hasErrors);

    // widget.profile
    return Scaffold(
      appBar: const StatusBar(),
      body: Center(
        child: hasErrors
            ? const ErrorScreen()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Heating',
                    style: TextStyle(fontSize: 32),
                  ),
                  Text('Caution: Do not open the door',
                      style: TextStyle(fontSize: 16)),
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
                            context.read<TmsService>().stopProfile(),
                            Navigator.pop(context),
                          },
                      child: const Text('Stop')),
                ],
              ),
      ),
    );
  }
}

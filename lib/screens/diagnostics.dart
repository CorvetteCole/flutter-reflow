import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/log_messages.dart';
import 'package:flutter_reflow/models/oven_status.dart';
import 'package:flutter_reflow/models/control_status.dart';
import 'package:flutter_reflow/models/reflow_status.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:provider/provider.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<LogMessages>(
              future: apiService.getLogMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.logs.isEmpty) {
                  return const Center(
                      child: Text('No log messages available.'));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.logs.length,
                    itemBuilder: (context, index) {
                      final logMessage = snapshot.data!.logs[index];
                      return ListTile(
                        title: Text(logMessage.message),
                        subtitle: Text(logMessage.time.toString()),
                      );
                    },
                  );
                }
              },
            ),
            Consumer<OvenStatus>(
              builder: (context, ovenStatus, child) {
                return ListTile(
                  title: const Text('Oven Status'),
                  subtitle: Text(
                    'Time: ${ovenStatus.time}\n'
                    'Temperature: ${ovenStatus.temperature}°C\n'
                    'State: ${ovenStatus.state}\n'
                    'Duty Cycle: ${ovenStatus.dutyCycle}\n'
                    'Door Open: ${ovenStatus.doorOpen}\n'
                    'Errors: ${ovenStatus.errors?.join(', ') ?? 'None'}',
                  ),
                );
              },
            ),
            Consumer<ReflowStatus>(
              builder: (context, reflowStatus, child) {
                return ListTile(
                  title: const Text('Control Status'),
                  subtitle: Text(
                    'State: ${reflowStatus.state}\n'
                    'Error: ${reflowStatus.error ?? 'None'}\n'
                    'Actual Temperatures: ${reflowStatus.actualTemperatures != null ? reflowStatus.actualTemperatures!.temperatures.join(', ') : 'Not available'}',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/tms/tms_status.dart';
import 'package:provider/provider.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _isLoading = false;

  void _reset() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request after the button is pressed
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final errors =
        context.select<TmsStatus, List<TmsError>>((status) => status.errors);

    return Stack(
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(10),
            child:
        Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // use material error color
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 68),
              Text('Error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 45)),
              // for (var error in errors) Text('• $error'),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: errors.map((error) => Text(error.friendlyMessage)).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(),
              ),
              const Text('Press the button below to acknowledge',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              FilledButton.icon(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    minimumSize: const Size(300, 80),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        )),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

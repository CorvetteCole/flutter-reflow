import 'package:flutter/material.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:provider/provider.dart';

class OpenDoorScreen extends StatelessWidget {
  const OpenDoorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Please Open the Door!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'The oven needs to be ventilated. Open the door to continue.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_reflow/models/oven_status.dart';
import 'package:provider/provider.dart';

/// The preferred height of the status bar
const statusBarHeight = 32.0;

/// The elevation of the statusBar
// TODO: would prefer not to use this at all
const statusBarElevation = 1.0;

/// The spacing between provided children to be placed in the status bar
const statusBarChildrenSpacing = 10.0;

/// Represents a status bar, displaying essential information such as connection status, time, etc.
///
/// This widget is meant to be used as an [AppBar] for the [Scaffold] of a dashboard. Can be passed
/// a list of [Widget]s to display on the status bar.
class StatusBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? children;

  const StatusBar({Key? key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Material(
        // no elevation default :(
        elevation: appBarTheme.elevation ?? 0.0,
        color: Colors.black,
        shadowColor: appBarTheme.shadowColor,
        surfaceTintColor: appBarTheme.surfaceTintColor,
        shape: appBarTheme.shape,
        child: Container(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<OvenStatus, num>(
                    selector: (context, status) => status.temperature,
                    builder: (context, num currentTemperature, child) {
                      return Temperature(currentTemperature);
                    }),
              ],
            )));
  }

  @override
  Size get preferredSize => const Size.fromHeight(statusBarHeight);
}

class Temperature extends StatelessWidget {
  final num _temperature;
  late final Color _temperatureColor;

  Temperature(this._temperature, {Key? key}) : super(key: key) {
    // color white below 35 C, color red above 100 C, interpolate between based on temperature
    // calculate 0.0 -> 1.0 based on temperature range above

    if (_temperature < 100.0) {
      _temperatureColor = Color.lerp(Colors.white, Colors.orange,
          (_temperature.clamp(35.0, 100.0) - 35) / (100 - 35))!;
    } else {
      _temperatureColor = Color.lerp(Colors.orange, Colors.red,
          (_temperature.clamp(100.0, 250.0) - 100) / (250 - 100))!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.thermostat_outlined, size: 24, color: _temperatureColor),
      Text(
        '${_temperature.round()}°C',
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

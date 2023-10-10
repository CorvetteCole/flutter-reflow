import 'package:flutter/material.dart';

/// The preferred height of the status bar
const statusBarHeight = 35.0;

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
        color: appBarTheme.backgroundColor,
        shadowColor: appBarTheme.shadowColor,
        surfaceTintColor: appBarTheme.surfaceTintColor,
        shape: appBarTheme.shape,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Temperature(),
            const ConnectionStatus(),
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(statusBarHeight);
}

class Temperature extends StatelessWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        child: Row(children: [
          Icon(Icons.thermostat_outlined,
              size: 24, color: Theme.of(context).colorScheme.onBackground),
          Text(
            '165°C',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
        ]));
  }
}

/// Widget that displays the websocket connection status in a friendly manner
class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.monitor_heart_outlined,
        size: 24, color: Colors.green);
  }
}

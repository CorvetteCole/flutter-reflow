import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reflow/models/oven_status.dart';

import 'package:libserialport/libserialport.dart';
import 'package:flutter_reflow/screens/curve_select.dart';
import 'package:flutter_reflow/screens/error.dart';
import 'package:flutter_reflow/screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_reflow/widgets/status_bar.dart';
import 'package:logging/logging.dart';
import 'package:flutter_reflow/services/api_service.dart';
import 'package:flutter_reflow/services/socket_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'models/log_message.dart';
import 'models/reflow_curve.dart';
import 'models/reflow_status.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

final log = Logger('main');

void main() async {
  // set logger level to all
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Must add this line.
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(320, 480),
      center: true,
      // backgroundColor: Colors.transparent,
      // skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } on MissingPluginException catch (e) {
    log.warning('Missing plugin: $e');
  }

  final ApiService apiService = ApiService('http://localhost:5000');
  final Socket socket = io('http://localhost:5000',
      OptionBuilder().setTransports(['websocket']).build());
  final SocketService socketService = SocketService(socket);

  final providers = [
    StreamProvider<OvenStatus>.value(
        initialData: OvenStatus(
            time: 0,
            temperature: 0,
            state: OvenState.idle,
            dutyCycle: 0,
            doorOpen: false),
        value: socketService.ovenStatusStream),
    StreamProvider<ReflowStatus>.value(
        initialData: ReflowStatus(
            actualTemperatures: ReflowCurve(
                times: const <int>[], temperatures: const <double>[]),
            state: ControlState.idle),
        value: socketService.reflowStatusStream),
    StreamProvider<LogMessage>.value(
        initialData: LogMessage(
            severity: LogSeverity.info,
            message: 'Welcome to Flutter Reflow',
            time: DateTime.now().second),
        value: socketService.logMessageStream),
    Provider<ApiService>.value(value: apiService),
  ];

  runApp(MultiProvider(providers: providers, child: const BasicApp()));
}

class BasicApp extends StatelessWidget {
  const BasicApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xff001748)),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    CurveSelectPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StatusBar(),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.whatshot_outlined),
              selectedIcon: Icon(Icons.whatshot),
              label: 'Heat',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'Info',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ));
  }
}

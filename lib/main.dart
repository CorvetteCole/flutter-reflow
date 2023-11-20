import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reflow/models/tms/tms_log.dart';
import 'package:flutter_reflow/models/tms/tms_status.dart';
import 'package:flutter_reflow/screens/diagnostic.dart';
import 'package:libserialport/libserialport.dart';
import 'package:flutter_reflow/screens/curve_select.dart';
import 'package:flutter_reflow/screens/error.dart';
import 'package:flutter_reflow/screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_reflow/widgets/status_bar.dart';
import 'package:logging/logging.dart';
import 'package:flutter_reflow/services/tms_service.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

void main() async {
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  log.config('Available ports:');
  var i = 0;
  for (final name in SerialPort.availablePorts) {
    final sp = SerialPort(name);
    log.config('${++i}) $name');
    log.config('\tDescription: ${sp.description}');
    log.config('\tManufacturer: ${sp.manufacturer}');
    log.config('\tSerial Number: ${sp.serialNumber}');
    log.config('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
    log.config('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
    sp.dispose();
  }

  final tmsService = TmsService.connect();

  final tmsProvider =
      ChangeNotifierProvider<TmsService>.value(value: tmsService);

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

  final providers = [
    tmsProvider,
    StreamProvider<TmsStatus>.value(
        value: tmsService.statusStream, initialData: TmsStatus.unknown()),
    StreamProvider<TmsLog>.value(
        value: tmsService.logStream, initialData: TmsLog.unknown()),
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

  static const List<Widget> _pages = <Widget>[
    CurveSelectPage(),
    DiagnosticsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasErrors = context.select((TmsStatus status) => status.hasErrors);

    return Scaffold(
        appBar: const StatusBar(),
        body: Center(
          child: hasErrors
              ? const ErrorScreen()
              : _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: hasErrors
            ? const SizedBox(width: 0, height: 0)
            : NavigationBar(
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

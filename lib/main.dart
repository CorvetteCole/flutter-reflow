import 'package:flutter/material.dart';
import 'package:libserialport/libserialport.dart';
import 'package:flutter_reflow/widgets/curve_card.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_reflow/widgets/status_bar.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

void main() async {
  print('Available ports:');
  var i = 0;
  for (final name in SerialPort.availablePorts) {
    final sp = SerialPort(name);
    print('${++i}) $name');
    print('\tDescription: ${sp.description}');
    print('\tManufacturer: ${sp.manufacturer}');
    print('\tSerial Number: ${sp.serialNumber}');
    print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
    print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
    sp.dispose();
  }

  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
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

  runApp(const BasicApp());
}

class BasicApp extends StatelessWidget {
  const BasicApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
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
    HomePage(),
    InfoPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StatusBar(),
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
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Profile', style: TextStyle(fontSize: 40))),
        body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            CurveCard(),
            CurveCard(),
            CurveCard(),
            CurveCard(),
            CurveCard(),
            CurveCard(),
            CurveCard(),
            CurveCard(),
          ],
        )));
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Info Page'));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Page'));
  }
}

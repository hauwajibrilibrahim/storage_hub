import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared_prefs_demo.dart';
import 'hive_demo.dart';
import 'sqlite_demo.dart';
import 'file_storage_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  runApp(const StorageHubApp());
}

class StorageHubApp extends StatelessWidget {
  const StorageHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    SharedPrefsDemo(),
    HiveDemo(),
    SqliteDemo(),
    FileStorageDemo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'SharedPrefs',
          ),
          NavigationDestination(icon: Icon(Icons.dataset), label: 'Hive'),
          NavigationDestination(icon: Icon(Icons.table_chart), label: 'SQLite'),
          NavigationDestination(icon: Icon(Icons.file_present), label: 'File'),
        ],
      ),
    );
  }
}

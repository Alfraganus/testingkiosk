import 'package:flutter/material.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'dart:async';
import 'package:flutter/services.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Kiosk Mode App')),
      body: const Center(child: _Home()),
    ),
  );
}

class _Home extends StatefulWidget {
  const _Home();

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  @override

  late final Stream<KioskMode> _currentMode = watchKioskMode();

  void _showSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _handleStop(bool? didStop) {
    if (didStop == null || didStop == false) {
      _showSnackBar('Could not stop Kiosk Mode');
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _currentMode,
    builder: (context, snapshot) {
      final mode = snapshot.data ?? KioskMode.disabled;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            onPressed: mode == KioskMode.disabled
                ? () => startKioskMode().then((didStart) {
              if (!didStart) _showSnackBar('Failed to start Kiosk Mode');
            })
                : null,
            child: const Text('Start Kiosk Mode'),
          ),
          MaterialButton(
            onPressed: mode == KioskMode.enabled
                ? () => stopKioskMode().then(_handleStop)
                : null,
            child: const Text('Stop Kiosk Mode'),
          ),
          Text('Current Mode: $mode'),
        ],
      );
    },
  );
}

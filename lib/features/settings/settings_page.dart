import 'package:flutter/material.dart';

/// Settings. Minimal on purpose — a local-first app has little to configure.
// ponytail: add real toggles (theme, sleep timer) when the features exist.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Offline • Local-first • No account')),
    );
  }
}

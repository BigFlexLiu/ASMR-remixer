import 'package:flutter/material.dart';

import '../components/settings_components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: const [
          ThemeSelection(),
        ],
      ),
    );
  }
}

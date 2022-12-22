import 'package:flutter/material.dart';

import '../components/common_widgets.dart';
import '../components/settings_components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ThemeSelection(),
          CommonDivider(),
          CommonPadding(
              child: Text("Suggest a feature or contribute a sound?")),
          CommonPadding(child: ContactMe()),
          CommonDivider(),
          CommonPadding(child: Text("Have an opinion about this app?")),
          CommonPadding(child: RateMe()),
          CommonDivider(),
          // Currently unused as discord is not setup
          // CommonPadding(child: Text("Find others enjoying this app?")),
          // CommonPadding(child: FindMe())
        ],
      ),
    );
  }
}

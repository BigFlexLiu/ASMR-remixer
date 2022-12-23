import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Settings() {
    read();
  }

  // Saves settings
  Future<void> save() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("theme", theme.name);
  }

  // Read saved settings from memory
  Future<void> read() async {
    final SharedPreferences prefs = await _prefs;
    // Restore theme setting
    theme = ThemeMode.values.firstWhere(
        (element) => element.name == prefs.getString("theme"),
        orElse: () => ThemeMode.system);
  }

  set theme(ThemeMode newTheme) {
    _theme = newTheme;
    save();
    notifyListeners();
  }

  ThemeMode get theme => _theme;
}

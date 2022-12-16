import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;

  Settings();

  set theme(ThemeMode newTheme) {
    _theme = newTheme;
    notifyListeners();
  }

  ThemeMode get theme => _theme;
}

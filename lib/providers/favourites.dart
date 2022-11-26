import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites with ChangeNotifier {
  List<String> favouriteSounds = [];
  static const key = 'favouriteSounds';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void initState() {
    _prefs.then((prefs) {
      favouriteSounds = prefs.getStringList(key) ?? [];
      notifyListeners();
    });
  }

  void changeFavourite(String name) {
    if (favouriteSounds.contains(name)) {
      favouriteSounds.remove(name);
    } else {
      favouriteSounds.add(name);
    }
    saveFavourites();
    notifyListeners();
  }

  Future<void> saveFavourites() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("favouriteSounds", favouriteSounds);
  }
}

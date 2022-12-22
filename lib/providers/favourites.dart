import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites with ChangeNotifier {
  List<String> _favouriteSounds = [];
  static const key = 'favouriteSounds';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Favourites() {
    readFavourites();
  }

  void changeFavourite(String name) {
    String nameSimplified = name;
    if (favouriteSounds.contains(nameSimplified)) {
      _favouriteSounds.remove(nameSimplified);
    } else {
      _favouriteSounds.add(nameSimplified);
    }
    saveFavourites();
    notifyListeners();
  }

  bool contains(String sound) => favouriteSounds.contains(sound);

  Future<void> saveFavourites() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("favouriteSounds", _favouriteSounds);
  }

  Future<void> readFavourites() async {
    final SharedPreferences prefs = await _prefs;
    _favouriteSounds = prefs.getStringList("favouriteSounds") ?? [];
    notifyListeners();
  }

  List<String> get favouriteSounds => _favouriteSounds;
}

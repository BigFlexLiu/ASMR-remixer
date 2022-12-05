import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/util.dart';

class Favourites with ChangeNotifier {
  List<String> favouriteSounds = [];
  static const key = 'favouriteSounds';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Favourites() {
    readFavourites();
  }

  void changeFavourite(String name) {
    String nameSimplified = getSoundFriendlyName(name);
    if (favouriteSounds.contains(nameSimplified)) {
      favouriteSounds.remove(nameSimplified);
    } else {
      favouriteSounds.add(nameSimplified);
    }
    saveFavourites();
    notifyListeners();
  }

  bool contains(String sound) =>
      favouriteSounds.contains(getSoundFriendlyName(sound));

  Future<void> saveFavourites() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("favouriteSounds", favouriteSounds);
  }

  Future<void> readFavourites() async {
    final SharedPreferences prefs = await _prefs;
    favouriteSounds = prefs.getStringList("favouriteSounds") ?? [];
    notifyListeners();
  }
}

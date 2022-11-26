import 'package:asmr_maker/providers/remix.dart';
import 'package:flutter/material.dart';

class Playing extends ChangeNotifier {
  List<String> _soundsPlaying = []; // Name of sounds currently playing
  List<Remix> _remixesPlaying = [];

  bool isSoundPlaying(String name) {
    return _soundsPlaying.contains(name);
  }

  void changeSoundsPlaying(String name) {
    if (isSoundPlaying(name)) {
      _soundsPlaying.remove(name);
    } else {
      _soundsPlaying.add(name);
    }
    notifyListeners();
  }

  get soundsPlaying => _soundsPlaying;
  get remixesPlaying => remixesPlaying;
}

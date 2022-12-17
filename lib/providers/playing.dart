import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Playing extends ChangeNotifier {
  Map<String, AudioPlayer> _soundsPlaying = Map();
  List<Remix> _remixesPlaying = [];

  bool isSoundPlaying(String sourceName) {
    return _soundsPlaying.containsKey(sourceName);
  }

  // Play sound if not playing
  // Stop sound then play from start if already playing
  void playSound(String sourceName) {
    // Sound is already playing
    if (_soundsPlaying.containsKey(sourceName)) {
      _soundsPlaying[sourceName]!.stop();
      _soundsPlaying[sourceName]!.resume();
      notifyListeners();
      return;
    }
    // Sound is not already playing
    AudioPlayer player = AudioPlayer();
    player.play(AssetSource(sourceName));
    _soundsPlaying[sourceName] = player;
    // Delete from map of sounds playing when done
    player.onPlayerComplete.listen((event) {
      _soundsPlaying.remove(sourceName);
      notifyListeners();
    });
    notifyListeners();
  }

  get soundsPlaying => _soundsPlaying.keys;
  get remixesPlaying => remixesPlaying;
}

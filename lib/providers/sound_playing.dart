import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundsPlaying extends ChangeNotifier {
  final Map<String, AudioPlayer> _soundsPlaying = {};

  bool isSoundPlaying(String sourceName) {
    return _soundsPlaying.containsKey(sourceName);
  }

  // Play sound if not playing
  // Remove sound if already playing
  void playSound(String sourceName) {
    // Sound is already playing
    if (_soundsPlaying.containsKey(sourceName)) {
      _soundsPlaying[sourceName]!.stop();
      _soundsPlaying.remove(sourceName);
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
}

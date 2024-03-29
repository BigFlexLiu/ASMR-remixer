import 'dart:math';

import 'package:asmr_maker/providers/sound.dart';
import 'package:flutter/material.dart';

import '../components/enum_def.dart';

class Remix with ChangeNotifier {
  RemixModes _mode = RemixModes.overlay;
  final List<Sound> _sounds = [];
  String _name = "unnamed";
  // Only works with mode = RemixModes.overlay
  // Number of sounds played per minute
  int _soundsPerMinute = 30;
  // Number of seconds to fade the begining and end of each sound
  double _fade = 1;

  Remix();

  bool contains(String soundName) {
    return !sounds.every((element) => element.name != soundName);
  }

  Sound getSound(String soundName) {
    assert(contains(soundName));
    return sounds.firstWhere((element) => element.name == soundName);
  }

  // Add Sound if soundName not in remix
  // else remove soundName in remix
  void editSoundList(String soundName) {
    if (sounds.every((element) => element.name != soundName)) {
      Sound newSound = Sound(soundName);
      _sounds.add(newSound);
      newSound.addListener(() => notifyListeners());
      notifyListeners();
      return;
    }
    Sound sound = sounds.firstWhere((element) => element.name == soundName);
    _sounds.remove(sound);
    sound.removeListener(() => notifyListeners());

    notifyListeners();
  }

  void addSound(Sound sound) {
    _sounds.add(sound);
    sound.addListener(() {
      notifyListeners();
    });
    notifyListeners();
  }

  void addAllSounds(List<Sound> sounds) {
    for (Sound sound in sounds) {
      _sounds.add(sound);
      sound.addListener(() => notifyListeners());
    }
    notifyListeners();
  }

  set soundsPerMinute(int value) {
    if (value < soundsPerMinuteRange[0]) {
      _soundsPerMinute = soundsPerMinuteRange[0];
    } else {
      _soundsPerMinute = min(value, soundsPerMinuteRange[1]);
    }
    notifyListeners();
  }

  set fade(double value) {
    if (value < fadeRange[0]) {
      _fade = fadeRange[0];
    } else {
      _fade = min(value, fadeRange[1]);
    }
    notifyListeners();
  }

  set mode(RemixModes newMode) {
    _mode = newMode;
    notifyListeners();
  }

  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  int get soundsPerMinute => _soundsPerMinute;
  int get fadeAsMili => fade * 1000 ~/ 1;
  double get fade => _fade;
  RemixModes get mode => _mode;
  List<double> get fadeRange => [0, 3];
  List<int> get soundsPerMinuteRange => [10, 120];
  bool get hasSound => sounds.isNotEmpty;
  String get name => _name;
  List<Sound> get sounds => _sounds;

  Remix.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _mode = RemixModes.values
            .firstWhere((element) => element.toString() == json['mode']),
        _soundsPerMinute = json['soundsPerMinute'],
        _fade = json['fade'] {
    if (json['sounds'] == []) {
      return;
    }

    List<Sound> sounds = [];
    for (var e in (json['sounds'] as List)) {
      sounds.add(Sound.fromJson(e));
    }
    addAllSounds(sounds);
  }

  Map<String, dynamic> toJson() => {
        "mode": _mode.toString(),
        "sounds": sounds.map((e) => e.toJson()).toList(),
        "name": name,
        "soundsPerMinute": soundsPerMinute,
        "fade": fade,
      };
}

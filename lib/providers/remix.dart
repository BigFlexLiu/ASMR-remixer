import 'dart:math';

import 'package:asmr_maker/providers/sound.dart';
import 'package:flutter/material.dart';

import '../components/enum_def.dart';

class Remix with ChangeNotifier {
  RemixModes mode = RemixModes.overlay;
  List<Sound> sounds = [];
  String name = "unnamed";
  // Only works with mode = RemixModes.overlay
  // Number of sounds played per minute
  int _soundsPerMinute = 10;
  // Number of seconds to fade the begining and end of each sound
  double _fade = 1;

  Remix();

  bool isSoundInRemix(String soundName) {
    return !sounds.every((element) => element.name != soundName);
  }

  Sound getSound(String soundName) {
    assert(isSoundInRemix(soundName));
    return sounds.firstWhere((element) => element.name == soundName);
  }

  // Add Sound if soundName not in remix
  // else remove soundName in remix
  void editSoundList(String soundName) {
    if (sounds.every((element) => element.name != soundName)) {
      Sound newSound = Sound(soundName);
      sounds.add(newSound);
      newSound.addListener(() => notifyListeners());
      notifyListeners();
      return;
    }
    Sound sound = sounds.firstWhere((element) => element.name == soundName);
    sounds.remove(sound);
    sound.removeListener(() => notifyListeners());

    notifyListeners();
  }

  void AddSound(Sound sound) {
    sounds.add(sound);
    sound.addListener(() {
      notifyListeners();
      print("notifies remix");
    });
    notifyListeners();
  }

  int get soundsPerMinute => _soundsPerMinute;
  set soundsPerMinute(int value) {
    if (value < soundsPerMinuteRange[0]) {
      _soundsPerMinute = soundsPerMinuteRange[0];
    } else {
      _soundsPerMinute = min(value, soundsPerMinuteRange[1]);
    }
    notifyListeners();
  }

  double get fade => _fade;
  set fade(double value) {
    if (value < fadeRange[0]) {
      _fade = fadeRange[0];
    } else {
      _fade = min(value, fadeRange[1]);
    }
    notifyListeners();
  }

  List<double> get fadeRange => [0, 3];
  List<int> get soundsPerMinuteRange => [1, 60];

  Remix.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mode = RemixModes.values
            .firstWhere((element) => element.toString() == json['mode']),
        _soundsPerMinute = json['soundsPerMinute'],
        _fade = json['fade'] {
    if (json['sounds'] == []) {
      return;
    }

    for (var e in (json['sounds'] as List)) {
      AddSound(Sound.fromJson(e));
    }
  }

  Map<String, dynamic> toJson() => {
        "mode": mode.toString(),
        "sounds": sounds.map((e) => e.toJson()).toList(),
        "name": name,
        "soundsPerMinute": soundsPerMinute,
        "fade": fade,
      };
}

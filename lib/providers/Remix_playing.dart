import 'dart:math';

import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/providers/sound.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/enum_def.dart';

class RemixPlaying extends ChangeNotifier {
  RemixPlaying();
  List<RemixPlayer> _remixPlayers = [];

  void play(Remix remix) {
    assert(!contains(remix));
    RemixPlayer player = RemixPlayer(remix);
    _remixPlayers.add(player);
    notifyListeners();
  }

  void stop(Remix remix) {
    assert(contains(remix));
    _findPlayer(remix).stop();
    _remixPlayers.remove(_findPlayer(remix));
    notifyListeners();
  }

  RemixPlayer _findPlayer(Remix remix) {
    return _remixPlayers.firstWhere((element) => element.remix == remix);
  }

  bool contains(Remix remix) {
    return !_remixPlayers.every((element) => element.remix != remix);
  }
}

class RemixPlayer {
  Remix remix;
  double totalFrequency = 0;

  Map<double, Sound> frequencyMap = {};
  List<double> frequencyList = [0];
  List<AudioPlayer> players = [];

  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  RemixPlayer(this.remix) {
    totalFrequency = remix.sounds
        .fold(0, (previousValue, element) => element.frequency + previousValue);
    for (var sound in remix.sounds) {
      frequencyList.add(frequencyList.last + sound.frequency);
      frequencyMap[frequencyList.last] = sound;
    }
    play();

    isPlaying.addListener(() {
      if (isPlaying.value == true) {
        return;
      }
      for (var element in players) {
        element.stop();
      }
      players.clear();
    });
  }

  Future<void> play() async {
    isPlaying.value = true;
    if (remix.mode == RemixModes.sequential) {
      _playSequential();
    } else {
      _playOverlay();
    }
  }

  void stop() {
    isPlaying.value = false;
  }

  Future<void> _playSequential() async {
    assert(remix.mode == RemixModes.sequential);

    // Listen to when sound completes
    // Load to player next sound
    // Self recursion without hurting the stack (Check)
    AudioPlayer player = await playSound(_nextSound, playerList: players);
    player.onPlayerComplete.listen((event) {
      Sound sound = _nextSound;
      print("Playing ${sound.name}");
      setSound(sound, player).then((value) => value.resume());
    });
    isPlaying.addListener(() {
      player.stop();
    });
  }

  Future<void> _playOverlay() async {
    assert(remix.mode == RemixModes.overlay);
    List<AudioPlayer> players = [];

    playSound(_nextSound, playerList: players);

    while (isPlaying.value) {
      await Future.delayed(
          Duration(milliseconds: (_secondsTilNextSound * 1000).floor()),
          () => playSound(_nextSound).then((value) => players.add(value)));
    }
  }

  // Create new player to play given sound
  // If playerList is present, add the player to the list
  // When the player finishes, it is removed from the list
  Future<AudioPlayer> playSound(Sound sound,
      {List<AudioPlayer>? playerList}) async {
    AudioPlayer player = await setSound(sound, AudioPlayer());
    player.resume();
    if (playerList != null) {
      playerList.add(player);
      player.onPlayerComplete.listen((event) => playerList.remove(player));
    }
    return player;
  }

  // Import sound to player and return it
  Future<AudioPlayer> setSound(Sound sound, AudioPlayer player) async {
    await player.stop();
    await player.setSource(AssetSource(sound.name));
    await player.setVolume(sound.volume);
    await player.setBalance(sound.balance);
    return player;
  }

  // Get the smallest item in list >= value
  double _getCeilInList(double value) {
    int leftBound = 0;
    int rightBound = frequencyList.length;
    while (leftBound != rightBound) {
      int mid = (leftBound + rightBound) ~/ 2;
      if (value > frequencyList[mid]) {
        leftBound = mid + 1;
      } else if (value < frequencyList[mid]) {
        rightBound = mid;
      } else {
        return frequencyList[mid];
      }
    }
    return frequencyList[leftBound];
  }

  double get _secondsTilNextSound {
    assert(remix.mode == RemixModes.overlay);
    double mean = 60 / remix.soundsPerMinute;
    // Generate using exponential distribution with mean = seconds / sound
    // Function: y = - (1 / mu) * ln (x / mu), where mu is the mean and x is the random value
    double generatedValue = -1 / mean * log(Random().nextDouble() / mean);

    return generatedValue;
  }

  Sound get _nextSound =>
      frequencyMap[_getCeilInList(Random().nextDouble() * totalFrequency)]!;
}

import 'dart:async';
import 'dart:math';

import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/providers/sound.dart';
import 'package:asmr_maker/util/global_settings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/enum_def.dart';

class RemixPlaying extends ChangeNotifier {
  RemixPlaying();
  final List<RemixPlayer> _remixPlayers = [];

  void play(Remix remix) {
    assert(!contains(remix));
    if (remix.hasSound) {
      RemixPlayer player = RemixPlayer(remix);
      _remixPlayers.add(player);
      notifyListeners();
    }
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
    if (!remix.hasSound) {
      return;
    }

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
    isPlaying.addListener(() => player.stop());
    player.onPlayerComplete.listen((event) {
      player.stop();
      Sound sound = _nextSound;
      setSound(sound, player).then((value) {
        player.resume();

        _addFade(sound, player);
      });
    });
  }

  Future<void> _playOverlay() async {
    assert(remix.mode == RemixModes.overlay);

    playSound(_nextSound, playerList: players);

    while (true) {
      await Future.delayed(
          Duration(milliseconds: (_secondsTilNextSound * 1000).floor()), () {
        if (isPlaying.value) {
          playSound(_nextSound, playerList: players);
        }
      });
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
    // Fade
    _addFade(sound, player);

    return player;
  }

  // Import sound to player and return it
  Future<AudioPlayer> setSound(Sound sound, AudioPlayer player) async {
    await player.stop();
    await player.setSource(AssetSource(sound.name));
    await player.setVolume(sound.volume);
    if (IS_BALANCE_ENABLED) {
      await player.setBalance(sound.balance);
    }
    return player;
  }

  void _addFade(Sound sound, AudioPlayer player) async {
    if (remix.fade <= 0) {
      return;
    }
    double maxVolume = sound.volume;
    final playerDuration = await player.getDuration() as Duration;

    // Fade for set time in remix or half of the sound duration, whichever is shorter
    int fadeDuration =
        min(remix.fadeAsMili, playerDuration.inMilliseconds ~/ 2);
    Duration startFadeOutAfter =
        playerDuration - Duration(milliseconds: fadeDuration);

    // Fade in
    _fade(0.0, maxVolume, player, fadeDuration, true);

    Timer(startFadeOutAfter,
        () => _fade(maxVolume, 0.0, player, fadeDuration, false));
  }

  // fadeDuration is in miliseconds
  void _fade(double from, double to, AudioPlayer player, int fadeDuration,
      bool isFadeIn) async {
    const milisecPerStep = 40;
    final numSteps = (fadeDuration / milisecPerStep).ceil();
    final firstTick = DateTime.now().millisecondsSinceEpoch;
    final lastTick = firstTick + fadeDuration;
    double volumeIncrement = (to - from) / numSteps;
    double currentVol = from;

    // // Update the volume value on each interval ticks
    Timer.periodic(const Duration(milliseconds: milisecPerStep), (Timer t) {
      if (DateTime.now().millisecondsSinceEpoch >= lastTick) {
        t.cancel();
        if (isFadeIn) {
          player.setVolume(1);
        }
        return;
      }
      currentVol = isFadeIn
          ? min(currentVol + volumeIncrement, 1)
          : max(currentVol + volumeIncrement, 0);
      player.setVolume(currentVol);
    });
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
    double rate = remix.soundsPerMinute / 60;
    // Generate using exponential distribution
    double generatedValue = -1 / rate * log(1 - Random().nextDouble());

    return generatedValue;
  }

  Sound get _nextSound =>
      frequencyMap[_getCeilInList(Random().nextDouble() * totalFrequency)]!;
}

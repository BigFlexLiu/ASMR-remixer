import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:flutter/material.dart';

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

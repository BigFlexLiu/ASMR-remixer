import 'dart:convert';

import 'package:asmr_maker/providers/remix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/enum_def.dart';
import 'favourites.dart';

class SoundClips extends ChangeNotifier {
  List<String> _names = [];
  List<String> _unsortedNames = [];
  List<SortBy> _sorting = [];
  Remix? _remix;
  Favourites favourites;

  SoundClips(this.favourites) {
    _fetchSounds().then((value) {
      _unsortedNames = value;
      _names = value.sublist(0);
      notifyListeners();
    });
  }

  Future<List<String>> _fetchSounds() async {
    var assets = await rootBundle.loadString('AssetManifest.json');
    Map<String, dynamic> json = jsonDecode(assets);
    List<String> sounds =
        json.keys.where((element) => element.endsWith(".mp3")).toList();
    return sounds;
  }

  void _sort() {
    _names = _unsortedNames.sublist(0);
    for (var sort in _sorting) {
      switch (sort) {
        case SortBy.added:
          if (_remix == null) {
            break;
          }
          _names.sort(((a, b) {
            if (_remix!.contains(a) == _remix!.contains(b)) {
              return 0;
            }
            return _remix!.contains(a) ? -1 : 1;
          }));
          break;
        case SortBy.favourite:
          _names.sort((a, b) {
            if (favourites.contains(a) == favourites.contains(b)) {
              return 0;
            }
            return favourites.contains(a) ? -1 : 1;
          });
          break;
        case SortBy.reverse:
          _names = _names.reversed.toList();
          break;
        default:
      }
    }
    notifyListeners();
  }

  void addSorting(SortBy sortby) {
    if (sorting.contains(sortby)) {
      sorting.remove(sortby);
    } else {
      sorting.add(sortby);
    }
    _sort();
  }

  List<String> get names => _names;
  List<SortBy> get sorting => _sorting;

  set remix(Remix? newRemix) {
    _remix = newRemix;
    notifyListeners();
  }
}

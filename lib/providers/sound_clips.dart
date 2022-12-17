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
      // Remove "Asset/" from the name
      for (var element in value) {
        _unsortedNames.add(element.substring(7));
      }
      _names = _unsortedNames.sublist(0);
      notifyListeners();
    });
    favourites.addListener(() {
      if (_sorting.contains(SortBy.favourite)) {
        _sort();
      }
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
    if (_sorting.contains(SortBy.favourite)) {
      _names.sort((a, b) {
        if (favourites.contains(a) == favourites.contains(b)) {
          return 0;
        }
        return favourites.contains(a) ? -1 : 1;
      });
    }
    if (_sorting.contains(SortBy.added) && _remix != null) {
      _names.sort(((a, b) {
        if (_remix!.contains(a) == _remix!.contains(b)) {
          return 0;
        }
        return _remix!.contains(a) ? -1 : 1;
      }));
    }
    if (_sorting.contains(SortBy.reverse)) {
      _names = _names.reversed.toList();
    }
    notifyListeners();
  }

  // Calls sort if sortings include type
  void sortIfType(SortBy type) {
    if (_sorting.contains(type)) {
      _sort();
    }
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
  bool get hasRemix => _remix != null;

  set remix(Remix? newRemix) {
    _remix = newRemix;
    _sort();
    notifyListeners();
  }
}

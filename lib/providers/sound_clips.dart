import 'dart:convert';

import 'package:asmr_maker/providers/remix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/enum_def.dart';
import 'favourites.dart';

class SoundClips extends ChangeNotifier {
  List<String> _names = [];
  final List<String> _unsortedNames = [];
  final List<SortBy> _sorting = [];
  Remix? _remix;
  final Favourites _favourites;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SoundClips(this._favourites) {
    initialize();
  }

  void initialize() async {
    // Get sound path
    var soundPaths = await _fetchSounds();
    // Remove "Asset/" from the path
    for (var path in soundPaths) {
      _unsortedNames.add(path.substring(7));
    }
    // Make deep copy of the paths
    _names = _unsortedNames.sublist(0);
    await readSortings();

    _favourites.addListener(() {
      if (_sorting.contains(SortBy.favourite)) {
        _sort();
      }
    });
    notifyListeners();
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
    saveSortings();
    if (sorting.contains(sortby)) {
      sorting.remove(sortby);
    } else {
      sorting.add(sortby);
    }
    _sort();
  }

  // Saves _sortings to memory
  Future<void> saveSortings() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setStringList("sortings", sorting.map((e) => e.name).toList());
  }

  // Read _sortings from memory
  Future<void> readSortings() async {
    final SharedPreferences prefs = await _prefs;
    // Get sortby stored
    _sorting.addAll(prefs
            .getStringList("sortings")
            ?.map(
                (e) => SortBy.values.firstWhere((element) => element.name == e))
            .toList() ??
        []);
    _sort();
  }

  List<String> get names => _names;
  List<SortBy> get sorting => _sorting;
  bool get hasRemix => _remix != null;
  Favourites get favourites => _favourites;

  set remix(Remix? newRemix) {
    _remix = newRemix;
    _sort();
    notifyListeners();
  }
}

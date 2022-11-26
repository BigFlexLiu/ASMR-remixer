import 'dart:convert';
import 'dart:io';

import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/providers/sound.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../components/enum_def.dart';

class Remixes with ChangeNotifier {
  List<Remix> _remixes = [];

  Remixes() {
    initState();
    addListener(() {
      print("Remixes listeners called");
    });
  }

  void initState() {
    _getStoredData();
    addListener(() => save());
  }

  void addRemix(Remix remix) {
    _remixes.add(remix);
    remix.addListener(() => notifyListeners());
    save();
    notifyListeners();
  }

  void removeRemix(Remix remix) {
    _remixes.remove(remix);
    remix.removeListener(() => notifyListeners());
    save();
    notifyListeners();
  }

  Future<File> _getStorageFile() async {
    Directory path = await getApplicationDocumentsDirectory();
    File file = File('${path.path}/remixes.json');
    return file;
  }

  Future<void> _getStoredData() async {
    print("Reading");
    try {
      final file = await _getStorageFile();
      final fileExists = await file.exists();
      if (fileExists) {
        final content = await file.readAsString();
        print(content);
        _remixes = Remixes.fromJson(json.decode(content)).remixes;
        listenToRemixes();
        notifyListeners();
        print("Read");
      }
    } catch (e) {
      print("Read failed");
      print(e);
      return;
    }
  }

  save() async {
    print("Saving");
    try {
      final file = await _getStorageFile();
      file.writeAsString(json.encode(toJson()));
      print("Saved");
    } catch (e) {
      print("Save failed");
      print(e);
      return 0;
    }
  }

  void listenToRemixes() {
    for (Remix remix in remixes) {
      remix.addListener(() => notifyListeners());
    }
  }

  Remixes.fromJson(Map<String, dynamic> json)
      : _remixes = (json['remixes'] as List)
            .map<Remix>((e) => Remix.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() =>
      {"remixes": remixes.map((e) => e.toJson()).toList()};

  List<Remix> get remixes => _remixes;
}

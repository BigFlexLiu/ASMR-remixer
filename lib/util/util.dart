import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> fetchSounds() async {
  var assets = await rootBundle.loadString('AssetManifest.json');
  Map<String, dynamic> json = jsonDecode(assets);
  List<String> sounds =
      json.keys.where((element) => element.endsWith(".mp3")).toList();
  return sounds;
}

String getSoundFriendlyName(String sourceFile) => sourceFile
    .split('/')
    .last
    .replaceAll('_', " ")
    .replaceAll("%20", " ")
    .replaceAll(".mp3", "");

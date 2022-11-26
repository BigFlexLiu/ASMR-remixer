import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:asmr_maker/components/enum_def.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/remix.dart';
import '../providers/sound.dart';

Future<List<String>> fetchSounds() async {
  var assets = await rootBundle.loadString('AssetManifest.json');
  Map<String, dynamic> json = jsonDecode(assets);
  List<String> sounds =
      json.keys.where((element) => element.endsWith(".mp3")).toList();
  return sounds;
}

String getSoundFriendlyName(String sourceFile) =>
    sourceFile.split('/').last.replaceAll('_', " ").replaceAll(".mp3", "");

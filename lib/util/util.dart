import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../pages/remix_settings.dart';
import '../providers/remix.dart';
import '../providers/sound_clips.dart';
import '../providers/sound_playing.dart';

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

void goToRemixPage(BuildContext context, Remix remix) {
  context.read<SoundClips>().remix = remix;
  context.read<SoundsPlaying>().stopAllSounds();

  Navigator.push(context,
          MaterialPageRoute(builder: (context) => RemixSettings(remix)))
      .then((value) {
    context.read<SoundClips>().remix = null;
    context.read<SoundsPlaying>().stopAllSounds();
  });
}

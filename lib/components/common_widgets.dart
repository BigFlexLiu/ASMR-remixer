import 'package:asmr_maker/providers/playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.dart';
import '../providers/sound_file_name.dart';

class SoundList extends StatelessWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: Provider.of<SoundFileNames>(context).names.map((fileName) {
      List favourites = context.watch<Favourites>().favouriteSounds;
      String friendlyName = getSoundFriendlyName(fileName);
      String sourceName = fileName.substring(7);

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Text(
                    friendlyName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
              ),
              PlayButton(sourceName),
              FavouriteButton(favourites, friendlyName),
            ],
          ),
          CommonDivider()
        ],
      );
    }).toList());
  }
}

class CommonDivider extends StatelessWidget {
  const CommonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(thickness: 1.5);
  }
}

class PlayButton extends StatelessWidget {
  PlayButton(this.sourceName, {super.key});
  String sourceName;
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final friendlyName = getSoundFriendlyName(sourceName);
    return IconButton(
        onPressed: () {
          if (context.read<Playing>().isSoundPlaying(friendlyName)) {
            player.stop();
            context.read<Playing>().changeSoundsPlaying(friendlyName);
          } else {
            player.play(AssetSource(sourceName));
            context.read<Playing>().changeSoundsPlaying(friendlyName);

            // Remove from playing when audio ends
            player.onPlayerComplete.listen((event) {
              if (context.read<Playing>().isSoundPlaying(friendlyName)) {
                context.read<Playing>().changeSoundsPlaying(friendlyName);
              }
            });
          }
        },
        icon: Icon(context.watch<Playing>().isSoundPlaying(friendlyName)
            ? Icons.stop
            : Icons.play_arrow));
  }
}

class FavouriteButton extends StatelessWidget {
  FavouriteButton(this.favourites, this.soundName, {super.key});
  String soundName;
  List favourites;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<Favourites>().changeFavourite(soundName),
        icon: Icon(favourites.contains(soundName)
            ? Icons.favorite
            : Icons.favorite_outline));
  }
}

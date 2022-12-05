import 'package:asmr_maker/components/enum_def.dart';
import 'package:asmr_maker/providers/playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.dart';
import '../providers/sound_clips.dart';

class SoundList extends StatelessWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SortBar(),
        Expanded(
          child: ListView(
              children: Provider.of<SoundClips>(context).names.map((fileName) {
            String friendlyName = getSoundFriendlyName(fileName);

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
                    PlayButton(fileName),
                    FavouriteButton(friendlyName),
                  ],
                ),
                CommonDivider()
              ],
            );
          }).toList()),
        ),
      ],
    );
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
  FavouriteButton(this.soundName, {super.key});
  String soundName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<Favourites>().changeFavourite(soundName),
        icon: Icon(context.read<Favourites>().contains(soundName)
            ? Icons.favorite
            : Icons.favorite_outline));
  }
}

class SortBar extends StatelessWidget {
  const SortBar({super.key});
  final buttonPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    final soundClips = Provider.of<SoundClips>(context, listen: true);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Sort by favourite
      Expanded(
        child: Tooltip(
          message: "Sort by favourite",
          child: ElevatedButton(
            onPressed: () {
              soundClips.addSorting(SortBy.favourite);
            },
            child: Icon(Icons.favorite),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(buttonPadding),
                foregroundColor: soundClips.sorting.contains(SortBy.favourite)
                    ? Colors.black
                    : null),
          ),
        ),
      ),
      // Sort by added
      if (context.watch<SoundClips>().hasRemix)
        Expanded(
          child: Tooltip(
            message: "Sort by added",
            child: ElevatedButton(
              onPressed: () {
                soundClips.addSorting(SortBy.added);
              },
              child: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  padding: EdgeInsets.all(buttonPadding),
                  foregroundColor: soundClips.sorting.contains(SortBy.added)
                      ? Colors.black
                      : null),
            ),
          ),
        ),
      // Reverse list
      Expanded(
        child: Tooltip(
          message: "Sort by reverse",
          child: ElevatedButton(
            onPressed: () => soundClips.addSorting(SortBy.reverse),
            child: Icon(FaIcon(FontAwesomeIcons.sort).icon),
            style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(buttonPadding),
                foregroundColor: soundClips.sorting.contains(SortBy.reverse)
                    ? Colors.black
                    : null),
          ),
        ),
      ),
    ]);
  }
}

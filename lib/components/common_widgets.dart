import 'package:asmr_maker/components/enum_def.dart';
import 'package:asmr_maker/providers/sound_playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.dart';
import '../providers/sound_clips.dart';

class SoundList extends StatelessWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SortBar(),
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
                        margin: const EdgeInsets.all(8.0),
                        child: Text(
                          friendlyName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    PlayButton(fileName),
                    FavouriteButton(friendlyName),
                  ],
                ),
                const CommonDivider()
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
  const PlayButton(this.sourceName, {super.key});
  final String sourceName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<SoundsPlaying>().playSound(sourceName);
        },
        icon: Icon(context.watch<SoundsPlaying>().isSoundPlaying(sourceName)
            ? Icons.stop
            : Icons.play_arrow));
  }
}

class FavouriteButton extends StatelessWidget {
  const FavouriteButton(this.soundName, {super.key});
  final String soundName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<Favourites>().changeFavourite(soundName);
          context.read<SoundClips>().sortIfType(SortBy.favourite);
        },
        icon: Icon(context.watch<Favourites>().contains(soundName)
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
          child: OutlinedButton(
            onPressed: () {
              soundClips.addSorting(SortBy.favourite);
            },
            child: Icon(soundClips.sorting.contains(SortBy.favourite)
                ? Icons.favorite
                : Icons.favorite_border),
          ),
        ),
      ),
      // Sort by added
      if (context.watch<SoundClips>().hasRemix)
        Expanded(
          child: Tooltip(
            message: "Sort by added",
            child: OutlinedButton(
              onPressed: () {
                soundClips.addSorting(SortBy.added);
              },
              child: Icon(soundClips.sorting.contains(SortBy.added)
                  ? Icons.add_circle
                  : Icons.add_circle_outline),
            ),
          ),
        ),
      // Reverse list
      Expanded(
        child: Tooltip(
          message: "Reverse",
          child: OutlinedButton(
              onPressed: () => soundClips.addSorting(SortBy.reverse),
              // child: Icon(soundClips.sorting.contains(SortBy.reverse)
              //     ? FaIcon(FontAwesomeIcons.sortUp).icon
              //     : FaIcon(FontAwesomeIcons.sortDown).icon),
              child: Icon(soundClips.sorting.contains(SortBy.reverse)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward)),
        ),
      ),
    ]);
  }
}

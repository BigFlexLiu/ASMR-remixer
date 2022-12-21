import 'package:asmr_maker/components/enum_def.dart';
import 'package:asmr_maker/pages/remix_settings.dart';
import 'package:asmr_maker/pages/sound_setting.dart';
import 'package:asmr_maker/providers/remix_playing.dart';
import 'package:asmr_maker/providers/sound_playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/remix.dart';
import '../providers/remixes.dart';
import '../providers/sound.dart';
import '../providers/sound_clips.dart';
import 'common_widgets.dart';

class RemixList extends StatelessWidget {
  const RemixList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: Provider.of<Remixes>(context).remixes.map((remix) {
      return Column(
        children: [
          Row(
            children: [
              DeleteRemixButton(remix),
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Text(
                    remix.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              if (remix.hasSound) PlayRemixButton(remix),
              RemixSettingButton(remix),
            ],
          ),
          const CommonDivider()
        ],
      );
    }).toList());
  }
}

class DeleteRemixButton extends StatelessWidget {
  const DeleteRemixButton(this.remix, {super.key});
  final Remix remix;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete ${remix.name}?"),
                content: const Text("There is no undo button after deletion!"),
                actions: [
                  TextButton(
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<Remixes>().removeRemix(remix);
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: const Text("No"),
                      onPressed: () => Navigator.of(context).pop())
                ],
              );
            }),
        icon: const Icon(Icons.delete));
  }
}

class RemixSoundList extends StatefulWidget {
  const RemixSoundList(this.remix, {super.key});
  final Remix remix;

  @override
  State<RemixSoundList> createState() => _RemixSoundListState();
}

class _RemixSoundListState extends State<RemixSoundList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: Provider.of<SoundClips>(context).names.map((fileName) {
      String friendlyName = getSoundFriendlyName(fileName);
      bool isSoundInRemix = widget.remix.contains(fileName);
      Sound? sound = isSoundInRemix ? widget.remix.getSound(fileName) : null;

      return Column(
        children: [
          Row(
            children: [
              SoundAddButton(widget.remix, fileName,
                  () => setState(() => isSoundInRemix = !isSoundInRemix)),
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
              if (isSoundInRemix)
                SoundSettingButton(widget.remix.getSound(fileName)),
              PlayButton(fileName, settings: sound),
              FavouriteButton(fileName),
            ],
          ),
          const CommonDivider()
        ],
      );
    }).toList());
  }
}

// Adds sound to remix
class SoundAddButton extends StatefulWidget {
  const SoundAddButton(this.remix, this.soundName, this.changeIsSoundInRemix,
      {super.key});
  final Remix remix;
  final String soundName;
  final VoidCallback changeIsSoundInRemix;

  @override
  State<SoundAddButton> createState() => _SoundAddButtonState();
}

class _SoundAddButtonState extends State<SoundAddButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() => {widget.remix.editSoundList(widget.soundName)});
          widget.changeIsSoundInRemix();
          context.read<SoundClips>().sortIfType(SortBy.added);
        },
        icon: Icon(widget.remix.contains(widget.soundName)
            ? Icons.remove
            : Icons.add));
  }
}

class SoundSettingButton extends StatelessWidget {
  const SoundSettingButton(this.sound, {super.key});
  final Sound sound;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<SoundsPlaying>().stopSound(sound.name);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SoundSetting(sound)));
        },
        icon: const Icon(Icons.settings));
  }
}

class PlayRemixButton extends StatelessWidget {
  const PlayRemixButton(this.remix, {super.key});
  final Remix remix;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = Provider.of<RemixPlaying>(context).contains(remix);
    IconData icon = isPlaying ? Icons.stop : Icons.play_arrow;
    return IconButton(
        onPressed: () {
          if (isPlaying) {
            Provider.of<RemixPlaying>(context, listen: false).stop(remix);
          } else {
            Provider.of<RemixPlaying>(context, listen: false).play(remix);
          }
        },
        icon: Icon(icon));
  }
}

class RemixSettingButton extends StatelessWidget {
  const RemixSettingButton(this.remix, {super.key});
  final Remix remix;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Provider.of<RemixPlaying>(context, listen: false)
              .contains(remix)) {
            Provider.of<RemixPlaying>(context, listen: false).stop(remix);
          }
          goToRemixPage(context, remix);
        },
        icon: const Icon(Icons.settings));
  }
}

class RemixModeButton extends StatefulWidget {
  RemixModeButton(this.remix, this.onPressed, {super.key}) : mode = remix.mode;
  final Remix remix;
  final RemixModes mode;
  final VoidCallback onPressed;

  @override
  State<RemixModeButton> createState() => _RemixModeButtonState();
}

class _RemixModeButtonState extends State<RemixModeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size.fromHeight(50))),
        onPressed: widget.onPressed,
        child: Text(
          widget.mode.name,
          style: Theme.of(context).textTheme.titleLarge,
        ));
  }
}

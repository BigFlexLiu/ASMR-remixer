import 'package:asmr_maker/components/enum_def.dart';
import 'package:asmr_maker/pages/remix_settings.dart';
import 'package:asmr_maker/pages/sound_setting.dart';
import 'package:asmr_maker/providers/Remix_playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.dart';
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
                  child: Text(
                    remix.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
              ),
              if (remix.hasSound) PlayRemixButton(remix),
              RemixSettingButton(remix),
            ],
          ),
          CommonDivider()
        ],
      );
    }).toList());
  }
}

class DeleteRemixButton extends StatelessWidget {
  DeleteRemixButton(this.remix, {super.key});
  Remix remix;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete ${remix.name}?"),
                content: Text("There is no undo button after deletion!"),
                actions: [
                  TextButton(
                      child: Text("Yes"),
                      onPressed: () {
                        context.read<Remixes>().removeRemix(remix);
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                      child: Text("No"),
                      onPressed: () => Navigator.of(context).pop())
                ],
              );
            }),
        icon: const Icon(Icons.delete));
  }
}

class RemixSoundList extends StatefulWidget {
  RemixSoundList(this.remix, {super.key});
  Remix remix;

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

      return Column(
        children: [
          Row(
            children: [
              SoundAddButton(widget.remix, fileName,
                  () => setState(() => isSoundInRemix = !isSoundInRemix)),
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
              if (isSoundInRemix)
                SoundSettingButton(widget.remix.getSound(fileName)),
              PlayButton(fileName),
              FavouriteButton(fileName),
            ],
          ),
          CommonDivider()
        ],
      );
    }).toList());
  }
}

// Adds sound to remix
class SoundAddButton extends StatefulWidget {
  SoundAddButton(this.remix, this.soundName, this.changeIsSoundInRemix,
      {super.key});
  Remix remix;
  String soundName;
  VoidCallback changeIsSoundInRemix;

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
        },
        icon: Icon(widget.remix.contains(widget.soundName)
            ? Icons.remove
            : Icons.add));
  }
}

class SoundSettingButton extends StatelessWidget {
  SoundSettingButton(this.sound, {super.key});
  Sound sound;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => SoundSetting(sound))),
        icon: const Icon(Icons.settings));
  }
}

// TODO
class PlayRemixButton extends StatelessWidget {
  PlayRemixButton(this.remix, {super.key});
  Remix remix;

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
  RemixSettingButton(this.remix, {super.key});
  Remix remix;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Provider.of<RemixPlaying>(context, listen: false)
              .contains(remix)) {
            Provider.of<RemixPlaying>(context, listen: false).stop(remix);
          }
          context.read<SoundClips>().remix = remix;
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RemixSettings(remix)))
              .then((value) => context.read<SoundClips>().remix = null);
        },
        icon: const Icon(Icons.settings));
  }
}

class RemixModeButton extends StatefulWidget {
  RemixModeButton(this.remix, this.onPressed, {super.key}) : mode = remix.mode;
  Remix remix;
  RemixModes mode;
  VoidCallback onPressed;

  @override
  State<RemixModeButton> createState() => _RemixModeButtonState();
}

class _RemixModeButtonState extends State<RemixModeButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size.fromHeight(50))),
        onPressed: widget.onPressed,
        child: Text(
          widget.mode.name,
          style: Theme.of(context).textTheme.titleLarge,
        ));
  }
}

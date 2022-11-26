import 'package:asmr_maker/pages/remix_settings.dart';
import 'package:asmr_maker/pages/sound_setting.dart';
import 'package:asmr_maker/providers/Remix_playing.dart';
import 'package:asmr_maker/providers/playing.dart';
import 'package:asmr_maker/util/util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.dart';
import '../providers/remix.dart';
import '../providers/remixes.dart';
import '../providers/sound.dart';
import '../providers/sound_file_name.dart';
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
              PlayRemixButton(remix),
              RemixSettingButton(remix),
            ],
          ),
          CommonDivider()
        ],
      );
    }).toList());
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
        children: Provider.of<SoundFileNames>(context, listen: false)
            .names
            .map((fileName) {
      List favourites = context.watch<Favourites>().favouriteSounds;
      String soundName = getSoundFriendlyName(fileName.substring(7));
      bool isSoundInRemix = widget.remix.isSoundInRemix(soundName);

      return Column(
        children: [
          Row(
            children: [
              SoundAddButton(widget.remix, soundName,
                  () => setState(() => isSoundInRemix = !isSoundInRemix)),
              Expanded(
                flex: 5,
                child: Container(
                  child: Text(
                    soundName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
              ),
              PlayRemixButton(widget.remix),
              FavouriteButton(favourites, soundName),
              if (isSoundInRemix)
                SoundSettingButton(widget.remix.getSound(soundName)),
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
        icon: Icon(widget.remix.isSoundInRemix(widget.soundName)
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
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => RemixSettings(remix))),
        icon: const Icon(Icons.settings));
  }
}

import 'package:asmr_maker/components/enum_def.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/common_widgets.dart';
import '../components/remix_components.dart';
import '../providers/remix.dart';
import '../providers/remixes.dart';

class RemixSettings extends StatefulWidget {
  const RemixSettings(this.remix, {super.key});
  final Remix remix;

  @override
  State<RemixSettings> createState() => _RemixSettingsState();
}

class _RemixSettingsState extends State<RemixSettings> {
  String newRemixName = 'unnamed';
  final remixOptions = RemixModes.values;
  late double fade;
  late int soundsPerMinute;
  late RemixModes mode;

  bool overlay = false;

  @override
  void initState() {
    super.initState();
    fade = widget.remix.fade;
    soundsPerMinute = widget.remix.soundsPerMinute;
    mode = widget.remix.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.remix.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit remix name',
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit remix name'),
                  content: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Give your remix a new name'),
                    onChanged: (value) {
                      setState(() {
                        newRemixName = value;
                      });
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.remix.name = newRemixName;
                        });
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add remix',
                onPressed: () {
                  Provider.of<Remixes>(context, listen: false)
                      .addRemix(widget.remix);
                  Navigator.pop(context, 'OK');
                }),
          ],
        ),
        body: Column(children: [
          const SortBar(),
          const CommonDivider(),
          RemixModeButton(widget.remix, () {
            if (mode == RemixModes.overlay) {
              widget.remix.mode = RemixModes.sequential;
              setState(() {
                mode = RemixModes.sequential;
              });
              return;
            }
            setState(() {
              mode = RemixModes.overlay;
            });
            widget.remix.mode = RemixModes.overlay;
          }),
          const CommonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Fade"),
              Text("${fade.toStringAsFixed(2)} seconds")
            ],
          ),
          Slider(
            value: fade,
            onChanged: (value) => setState(() => fade = value),
            onChangeEnd: (value) => widget.remix.fade = value,
            min: widget.remix.fadeRange[0],
            max: widget.remix.fadeRange[1],
          ),
          const CommonDivider(),
          if (mode == RemixModes.overlay)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sounds"),
                Text("$soundsPerMinute per minute")
              ],
            ),
          if (mode == RemixModes.overlay)
            Slider(
              value: soundsPerMinute.toDouble(),
              onChanged: (value) =>
                  setState(() => soundsPerMinute = value.toInt()),
              onChangeEnd: (value) =>
                  widget.remix.soundsPerMinute = value.toInt(),
              min: widget.remix.soundsPerMinuteRange[0].toDouble(),
              max: widget.remix.soundsPerMinuteRange[1].toDouble(),
              divisions: (widget.remix.soundsPerMinuteRange[1] -
                      widget.remix.soundsPerMinuteRange[0])
                  .round(),
            ),
          if (mode == RemixModes.overlay) const CommonDivider(),
          Expanded(flex: 5, child: RemixSoundList(widget.remix))
        ]));
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem(this.value, {super.key});
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

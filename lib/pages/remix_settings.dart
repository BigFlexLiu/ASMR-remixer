import 'package:asmr_maker/components/enum_def.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/common_widgets.dart';
import '../components/remix_components.dart';
import '../providers/remix.dart';
import '../providers/remixes.dart';

class RemixSettings extends StatefulWidget {
  RemixSettings(this.remix, {super.key})
      : fade = remix.fade,
        soundsPerMinute = remix.soundsPerMinute,
        mode = remix.mode;
  Remix remix;
  double fade;
  int soundsPerMinute;
  RemixModes mode;

  @override
  State<RemixSettings> createState() => _RemixSettingsState();
}

class _RemixSettingsState extends State<RemixSettings> {
  String newRemixName = 'unnamed';
  final remixOptions = RemixModes.values;

  bool overlay = false;

  @override
  void initState() {
    super.initState();
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
                    decoration: InputDecoration(
                        labelText: newRemixName, hintText: 'unnamed'),
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
          SortBar(),
          CommonDivider(),
          RemixModeButton(widget.remix, () {
            if (widget.mode == RemixModes.overlay) {
              widget.remix.mode = RemixModes.sequential;
              setState(() {
                widget.mode = RemixModes.sequential;
              });
              return;
            }
            setState(() {
              widget.mode = RemixModes.overlay;
            });
            widget.remix.mode = RemixModes.overlay;
          }),
          CommonDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Fade"),
              Text(widget.fade.toStringAsFixed(2) + " seconds")
            ],
          ),
          Slider(
            value: widget.fade,
            onChanged: (value) => setState(() => widget.fade = value),
            onChangeEnd: (value) => widget.remix.fade = value,
            min: widget.remix.fadeRange[0],
            max: widget.remix.fadeRange[1],
          ),
          CommonDivider(),
          if (widget.mode == RemixModes.overlay)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sounds"),
                Text(widget.soundsPerMinute.toString() + " per minute")
              ],
            ),
          if (widget.mode == RemixModes.overlay)
            Slider(
              value: widget.soundsPerMinute.toDouble(),
              onChanged: (value) =>
                  setState(() => widget.soundsPerMinute = value.toInt()),
              onChangeEnd: (value) =>
                  widget.remix.soundsPerMinute = value.toInt(),
              min: widget.remix.soundsPerMinuteRange[0].toDouble(),
              max: widget.remix.soundsPerMinuteRange[1].toDouble(),
              divisions: (widget.remix.soundsPerMinuteRange[1] -
                      widget.remix.soundsPerMinuteRange[0])
                  .round(),
            ),
          if (widget.mode == RemixModes.overlay) CommonDivider(),
          Expanded(flex: 5, child: RemixSoundList(widget.remix))
        ]));
  }
}

class CarouselItem extends StatelessWidget {
  CarouselItem(this.value, {super.key});
  String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

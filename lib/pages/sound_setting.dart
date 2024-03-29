import 'package:asmr_maker/components/settings_components.dart';
import 'package:asmr_maker/util/global_settings.dart';
import 'package:flutter/material.dart';
import '../providers/sound.dart';

class SoundSetting extends StatefulWidget {
  SoundSetting(this.sound, {super.key})
      : volume = sound.volume,
        frequency = sound.frequency,
        balance = sound.balance;
  Sound sound;
  double volume;
  double frequency;
  double balance;

  @override
  State<SoundSetting> createState() => _SoundSettingState();
}

class _SoundSettingState extends State<SoundSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sound setting")),
      body: Column(children: [
        CommonPadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Volume"),
              Text(widget.volume.toStringAsFixed(2))
            ],
          ),
        ),
        Slider(
          value: widget.volume,
          onChanged: (value) => setState(() => widget.volume = value),
          onChangeEnd: (value) => widget.sound.volume = value,
          min: widget.sound.volumeRange[0],
          max: widget.sound.volumeRange[1],
        ),
        CommonPadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Frequency"),
              Text(widget.frequency.toStringAsFixed(2))
            ],
          ),
        ),
        Slider(
          value: widget.frequency,
          onChanged: (value) => setState(() => widget.frequency = value),
          onChangeEnd: (value) => widget.sound.frequency = value,
          min: widget.sound.frequencyRange[0],
          max: widget.sound.frequencyRange[1],
        ),
        if (isBalanceEnabled)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Balance"),
              Text(widget.balance.toStringAsFixed(2))
            ],
          ),
        if (isBalanceEnabled)
          Slider(
            value: widget.balance,
            onChanged: (value) => setState(() => widget.balance = value),
            onChangeEnd: (value) => widget.sound.balance = value,
            min: widget.sound.balanceRange[0],
            max: widget.sound.balanceRange[1],
          ),
        TextButton(
            onPressed: () {
              widget.sound.reset();
              setState(() {
                widget.volume = widget.sound.volume;
                widget.frequency = widget.sound.frequency;
                widget.balance = widget.sound.balance;
              });
            },
            child: const Text("Reset"))
      ]),
    );
  }
}

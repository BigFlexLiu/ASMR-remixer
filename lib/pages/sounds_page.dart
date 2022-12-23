import 'package:asmr_maker/components/common_widgets.dart';
import 'package:flutter/material.dart';

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  List sounds = [];
  List playing = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sounds'),
      ),
      body: const SoundList(),
    );
  }
}

import 'dart:convert';

import 'package:asmr_maker/components/common_widgets.dart';
import 'package:asmr_maker/providers/favourites.dart';
import 'package:asmr_maker/providers/sound_file_name.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../util/util.dart';

class CollectionPage extends StatefulWidget {
  CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  List sounds = [];
  List playing = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collections'),
      ),
      body: SoundList(),
    );
  }
}

import 'package:asmr_maker/components/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

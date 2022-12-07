import 'dart:convert';

import 'package:asmr_maker/pages/collection_page.dart';
import 'package:asmr_maker/pages/favourite_page.dart';
import 'package:asmr_maker/pages/remix_page.dart';
import 'package:asmr_maker/providers/Remix_playing.dart';
import 'package:asmr_maker/providers/favourites.dart';
import 'package:asmr_maker/providers/playing.dart';
import 'package:asmr_maker/providers/remix.dart';
import 'package:asmr_maker/providers/remixes.dart';
import 'package:asmr_maker/providers/sound.dart';
import 'package:asmr_maker/providers/sound_clips.dart';
import 'package:asmr_maker/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final favourites = Favourites();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => favourites), // Contains favourited sounds
        ChangeNotifierProvider(
            create: (_) => SoundClips(favourites)), // For ordering sound lists
        ChangeNotifierProvider(
            create: (_) =>
                Remixes()), // Contains all the remixes the user created
        ChangeNotifierProvider(
          // Contains all the sounds that are currently playing
          create: (_) => Playing(),
        ),
        ChangeNotifierProvider(
          // Contains all the remixes that are currently playing
          create: (_) => RemixPlaying(),
        ),
      ],
      child: MaterialApp(
        title: 'ASMR Remixer',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black),
              titleMedium: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black),
              titleSmall: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black,
              ),
            )),
        darkTheme: darkTheme,
        home: MainScreen(),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MainScreen extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  final screens = <Widget>[CollectionPage(), RemixPage()];
  @override
  Widget build(BuildContext context) {
    return Center(child: PageView.builder(itemBuilder: (context, position) {
      return screens[position % screens.length];
    }));
  }
}

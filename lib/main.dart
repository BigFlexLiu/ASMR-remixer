import 'package:asmr_maker/pages/collection_page.dart';
import 'package:asmr_maker/pages/remix_page.dart';
import 'package:asmr_maker/pages/settings_page.dart';
import 'package:asmr_maker/providers/remix_playing.dart';
import 'package:asmr_maker/providers/favourites.dart';
import 'package:asmr_maker/providers/sound_playing.dart';
import 'package:asmr_maker/providers/remixes.dart';
import 'package:asmr_maker/providers/settings.dart';
import 'package:asmr_maker/providers/sound_clips.dart';
import 'package:asmr_maker/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final favourites = Favourites();

    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) => favourites), // Contains favourited sounds
      ChangeNotifierProvider(
          create: (_) => SoundClips(favourites)), // For ordering sound lists
      ChangeNotifierProvider(
          create: (_) =>
              Remixes()), // Contains all the remixes the user created
      ChangeNotifierProvider(
        // Contains all the sounds that are currently playing
        create: (_) => SoundsPlaying(),
      ),
      ChangeNotifierProvider(
        // Contains all the remixes that are currently playing
        create: (_) => RemixPlaying(),
      ),
      ChangeNotifierProvider(
        // Contains all the remixes that are currently playing
        create: (_) => Settings(),
      ),
    ], child: const ThemeWraper());
  }
}

class ThemeWraper extends StatelessWidget {
  const ThemeWraper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      themeMode: context.watch<Settings>().theme,
      home: MainScreen(),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MainScreen extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  final screens = <Widget>[
    const CollectionPage(),
    const RemixPage(),
    const SettingsPage()
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: PageView.builder(itemBuilder: (context, position) {
      return screens[position % screens.length];
    }));
  }
}

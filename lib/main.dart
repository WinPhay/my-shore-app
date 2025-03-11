import 'package:flutter/material.dart';
import 'package:my_shorebird_app/config/flavors.dart';
import 'package:my_shorebird_app/src/spotify_screen.dart';

class MainApp extends StatelessWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App - ${AppConfig.appFlavor}',
      home: const SpotifyScreen(),
    );
  }
}

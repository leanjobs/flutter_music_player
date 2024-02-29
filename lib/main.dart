import 'package:flutter/material.dart';
import 'package:music_player/pages/SplashScreen.dart';
import 'package:music_player/previews/Preview.dart';
import 'package:music_player/previews/Preview3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => SplashScreen(),
        "preview3": (context) => Preview3(),
      },
    );
  }
}

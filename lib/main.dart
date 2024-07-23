import 'package:flutter/material.dart';
import 'package:MyMusic/pages/HomeScreen.dart';
import 'package:MyMusic/pages/LikedScreen.dart';
import 'package:MyMusic/pages/MusicScreen.dart';
import 'package:MyMusic/pages/SearchScreen.dart';
import 'package:MyMusic/pages/SplashScreen.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF191A1E),
      ),
      routes: {
        "/": (context) => SplashScreen(),
      },
    );
  }
}

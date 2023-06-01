import 'package:flutter/material.dart';
import 'package:maxflix/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const int _primarycolorPrimaryValue = 0xFF00384C;
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaxFlix',
      theme: ThemeData(
        primarySwatch: const MaterialColor(_primarycolorPrimaryValue, <int, Color>{
          50: Color(0xFFE0E7EA),
          100: Color(0xFFB3C3C9),
          200: Color(0xFF809CA6),
          300: Color(0xFF4D7482),
          400: Color(0xFF265667),
          500: Color(_primarycolorPrimaryValue),
          600: Color(0xFF003245),
          700: Color(0xFF002B3C),
          800: Color(0xFF002433),
          900: Color(0xFF001724),
        }),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

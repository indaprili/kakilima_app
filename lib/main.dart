import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart'; // Import splash screen

void main() {
  runApp(const KakiLimaApp());
}

class KakiLimaApp extends StatelessWidget {
  const KakiLimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KakiLima',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(), // Ganti dari LoginPage ke SplashScreen
    );
  }
}

import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay 5 detik lalu pindah ke LoginPage
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Image.asset(
          'assets/logo_kakilima.png',
          width: screenSize.width * 0.5, // 50% dari lebar layar
          height: screenSize.width * 0.5, // biar tetap proporsional
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

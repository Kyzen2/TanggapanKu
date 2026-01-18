import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/pages/login.dart';
import 'package:tanggapanku/pages/timeline_page.dart';
import 'package:tanggapanku/models/warga.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userStr = prefs.getString('user');

    if (token != null && userStr != null) {
      final wargaMap = jsonDecode(userStr);
      // OPTIONAL: Kalau butuh model
      // final warga = Warga.fromJson(wargaMap);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TimelinePage(
            userData: wargaMap,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2A6A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LOGO
            Image.asset(
              'assets/logo.png', // ganti sesuai path logo kamu
              width: 100,
              height: 100,
            ),

            const SizedBox(height: 16),

            // TEXT
            const Text(
              "TanggapanKu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // dikecilin
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            // LOADING BULAT
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

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
    return const Scaffold(
      body: Center(
        child: Text(
          "TANGGAPANKU",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      backgroundColor: Colors.deepPurple,
    );
  }
}

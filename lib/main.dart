// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/models/register.dart';
import 'package:tanggapanku/pages/login.dart';
import 'package:tanggapanku/pages/pengaduan.dart';
import 'package:tanggapanku/pages/pengaturan_page.dart';
import 'package:tanggapanku/pages/register.dart';
import 'package:tanggapanku/pages/timeline_page.dart';
// import 'pages/timeline_page.dart';
import 'pages/splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00B6A0)),
      ),
      home: const LoginPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/pages/login.dart'; // ganti sesuai halaman login

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Debug token
      print("🔹 Token sebelum logout: $token");

      if (token.isEmpty) {
        print("⚠️ Token kosong, langsung arahkan ke login");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }

      // Kirim request logout ke API
      final response = await http.post(
        Uri.parse('https://firmly-splendid-dove.ngrok-free.app/api/logout'), // ganti URL API
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Hapus token lokal
        await prefs.remove('token');
        print("✅ Logout sukses, token dihapus");

        // Arahkan ke login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        print("❌ Logout gagal: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal logout, coba lagi')),
        );
      }
    } catch (e, stacktrace) {
      print("🔥 Error saat logout: $e");
      print("📜 Stacktrace: $stacktrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error saat logout: $e')),
      );
    }
  }
}

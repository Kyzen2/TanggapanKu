import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tanggapanku/pages/timeline_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TanggapanKu App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  TextEditingController nikC = TextEditingController();
  TextEditingController passC = TextEditingController();
  bool _loading = false;

  // 🔥 Fungsi Login
  Future<void> login() async {
    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('https://firmly-splendid-dove.ngrok-free.app/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nik": nikC.text.trim(),
          "password": passC.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Login Berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!")),
        );

        // Ambil data user dari API
        print("== DEBUG RESPONSE ==");
        print(response.body);
        print("== DECODED DATA ==");
        print(data);

        final Map<String, dynamic> userData =
            data['warga']; // misal backend kirim 'user'

        // Pindah ke TimelinePage & kirim data user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TimelinePage(userData: userData),
          ),
        );
      } else {
        // ❌ Login Gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color accentBlue = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: primaryBlueDark,
      body: Column(
        children: [
          ClipPath(
            child: Container(
              height: screenHeight * 0.42 - keyboardHeight * 0.1,
              width: screenWidth,
              color: primaryBlueDark,
              child: Stack(
                children: [
                  Positioned(
                    bottom: -20,
                    right: 0,
                    child: Image.asset(
                      'assets/egi.png',
                      height: screenHeight * 0.9,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.08, left: screenWidth * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Log in',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.07,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/Logo.png',
                              height: screenWidth * 0.05,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        Text(
                          'TanggapanKU',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Text(
                          '"Pengaduan warga menjadi\nmudah dan praktis."',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      controller: nikC,
                      decoration: InputDecoration(
                        hintText: 'NIK',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person,
                            color: Colors.grey, size: screenWidth * 0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passC,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.grey, size: screenWidth * 0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                                () => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Lupa Password?',
                            style: GoogleFonts.poppins(
                                color: accentBlue,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                'Masuk',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    Text(
                      'Belum punya akun?',
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentBlue,
                          side: const BorderSide(color: accentBlue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                        ),
                        child: Text('Daftar',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

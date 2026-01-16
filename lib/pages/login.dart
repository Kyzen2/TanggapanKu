import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/pages/timeline_page.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/pages/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService api = ApiService();
  bool _isPasswordVisible = false;
  bool _loading = false;

  final TextEditingController nikC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  // LOGIN FUNCTION (bersih, rapi)
  Future<void> login() async {
    setState(() => _loading = true);

    try {
      final result = await api.loginUser(
        nikC.text.trim(),
        passC.text.trim(),
      );

      final status = result['status'];
      final body = result['body'];

      if (status == 200) {
        final userData = body['warga']; // FIX 1
        final token = body['token_jwt']; // FIX 2

        // SIMPAN TOKEN DAN USER DATA
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(userData)); // OPTIONAL

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TimelinePage(userData: userData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(body['message'] ?? "Login gagal"),
          ),
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
                      top: screenHeight * 0.08,
                      left: screenWidth * 0.07,
                    ),
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
                  vertical: screenHeight * 0.04,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nikC,
                        decoration: InputDecoration(
                          hintText: 'NIK',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: screenWidth * 0.06,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextField(
                        controller: passC,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: screenWidth * 0.06,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Lupa Password?',
                            style: GoogleFonts.poppins(
                              color: accentBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      ElevatedButton(
                        onPressed: _loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
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
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: Text(
                          'Belum punya akun?',
                          style: GoogleFonts.poppins(color: Colors.grey[700]),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentBlue,
                          side: const BorderSide(color: accentBlue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                        ),
                        child: Text(
                          'Daftar',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

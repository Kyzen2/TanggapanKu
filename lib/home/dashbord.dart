import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TanggapanKu App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color primaryPurple = Color(0xFF7A4DFB);
    const Color accentTeal = Color(0xFF4DD0E1);
    const Color lightGreyBg = Color(0xFFE0E0E0);
    const Color neonYellow = Color(0xFFF7F10C); // Warna kuning cerah/neon

    return Scaffold(
      backgroundColor: primaryPurple,
      body: Stack(
        children: [
          // Bagian atas dengan logo dan teks
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.45, // Meningkatkan tinggi container atas
              color: primaryPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  // Logo Container
                  Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      color: accentTeal,
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    child: Center(
                      child: Image.network(
                        'https://i.imgur.com/G5c862O.png',
                        color: Colors.white,
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.18,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.shield,
                              color: Colors.white, size: screenWidth * 0.18);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Teks "TANGGAPANku"
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.kanit(
                        fontSize: screenWidth * 0.13,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'TANGGAPAN',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'KU',
                          style:
                              TextStyle(color: neonYellow), // Kuning cerah/neon
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bagian bawah dengan form login
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.6, // Mengurangi tinggi container putih
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOGIN',
                      style: GoogleFonts.rubik(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Input NIK
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'NIK',
                        hintStyle: GoogleFonts.asapCondensed(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.04),
                        filled: true,
                        fillColor: lightGreyBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.05),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Input Password
                    TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.asapCondensed(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.04),
                        filled: true,
                        fillColor: lightGreyBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.05),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: screenWidth * 0.06,
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
                        onPressed: () {
                          // Handle Lupa Password
                        },
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.asapCondensed(
                              color: const Color(0xFF5D3AC6),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    // Tombol Masuk
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle Login
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                          ),
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.asapCondensed(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Teks "Belum punya akun?"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: GoogleFonts.asapCondensed(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.035),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle Daftar Sekarang
                          },
                          child: Text(
                            'Daftar Sekarang',
                            style: GoogleFonts.asapCondensed(
                              color: const Color(0xFF5D3AC6),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
          // Garis bawah tombol "Masuk"
          Positioned(
            bottom: screenHeight * 0.005,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 4,
                width: screenWidth * 0.3,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

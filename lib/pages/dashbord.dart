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
      debugShowCheckedModeBanner: false,
      title: 'TanggapanKu App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Tinggi yang diambil oleh keyboard
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color accentBlue = Color(0xFF3F51B5);
    const Color lightGrey = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: primaryBlueDark,
      // Menggunakan Column utama sebagai body Scaffold tanpa SingleChildScrollView
      body: Column(
        children: [
          // Bagian atas dengan gelombang
          ClipPath(
            child: Container(
              height: screenHeight * 0.42 -
                  keyboardHeight *
                      0.1, // Sedikit mengurangi tinggi jika keyboard muncul
              width: screenWidth,
              color: primaryBlueDark,
              child: Stack(
                children: [
                  // --- Tempat untuk menambahkan FOTO PEREMPUAN ---
                  // Jika foto akan ditambahkan, pastikan ukurannya tidak membuat overflow.
                  // Misalnya, sesuaikan tinggi dan posisi agar tidak bertabrakan dengan teks.
                  Positioned(
                    bottom: -20,
                    right: 0,
                    child: Image.asset(
                      'assets/egi.png',
                      height: screenHeight *
                          0.90, // Disesuaikan agar tidak terlalu tinggi
                      fit: BoxFit.cover,
                    ),
                  ),
                  // --------------------------------------------------
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
                            SizedBox(width: screenWidth * 0.02),
                            // Ganti bagian ini:
                            // Icon(Icons.flight, color: Colors.white, size: screenWidth * 0.05),

                            // Dengan ini:
                            Image.asset(
                              'assets/Logo.png', // Pastikan path ini benar
                              height: screenWidth *
                                  0.05, // Gunakan tinggi yang sama dengan ukuran ikon sebelumnya
                              fit:
                                  BoxFit.contain, // Agar gambar tidak terpotong
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

          // Bagian bawah dengan form login (menggunakan Expanded)
          Expanded(
            // Expanded akan mengambil sisa ruang yang tersedia
            child: Container(
              width: screenWidth,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // Gunakan MainAxisAlignment.spaceBetween untuk menyebar elemen
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Spasi atas ini bisa dihapus atau dikurangi jika pakai spaceBetween
                    // SizedBox(height: screenHeight * 0.02),

                    // Input NIK
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'NIK',
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.04),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person,
                            color: Colors.grey, size: screenWidth * 0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: accentBlue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.03),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.025), // Spasi ini bisa diatur oleh spaceBetween

                    // Input Password
                    TextField(
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: screenWidth * 0.04),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.grey, size: screenWidth * 0.06),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: accentBlue, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.03),
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
                    // SizedBox(height: screenHeight * 0.01), // Spasi ini bisa diatur oleh spaceBetween

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle Lupa Password
                        },
                        child: Text(
                          'Lupa Password?',
                          style: GoogleFonts.poppins(
                              color: accentBlue,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.035), // Spasi ini bisa diatur oleh spaceBetween

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Login
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                        ),
                        child: Text(
                          'Masuk',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.03), // Spasi ini bisa diatur oleh spaceBetween

                    Text(
                      'Belum punya akun?',
                      style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: screenWidth * 0.035),
                    ),
                    // SizedBox(height: screenHeight * 0.02), // Spasi ini bisa diatur oleh spaceBetween

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Daftar
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: accentBlue,
                          side: const BorderSide(color: accentBlue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                        ),
                        child: Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.06), // Spasi ini bisa diatur oleh spaceBetween

                    // Teks Legal
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[600]),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Dengan ini saya menyetujui\n'),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: GoogleFonts.poppins(
                                color: accentBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' dan '),
                            TextSpan(
                              text: 'Syarat Ketentuan Aplikasi',
                              style: GoogleFonts.poppins(
                                color: accentBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.02), // Spasi ini bisa diatur oleh spaceBetween
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

// CustomClipper untuk membuat bentuk gelombang
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.8);

    var firstControlPoint = Offset(size.width * 0.25, size.height);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

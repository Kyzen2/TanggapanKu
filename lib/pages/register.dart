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
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color accentBlue = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: primaryBlueDark,
      // Hapus SingleChildScrollView
      body: Column(
        children: [
          // Bagian atas
          // Menurunkan tinggi bagian atas agar ada lebih banyak ruang untuk form
          Container(
            height: screenHeight * 0.35, // Disesuaikan agar lebih kecil
            width: screenWidth,
            color: primaryBlueDark,
            child: Stack(
              children: [
                Positioned(
                  // Sesuaikan posisi gambar agar tetap terlihat proporsional
                  bottom: -screenHeight * 0.16, // sedikit lebih tinggi
                  right: -screenWidth * 0.04,
                  child: Image.asset(
                    'assets/egi.png',
                    height: screenHeight * 0.65, // Tinggi gambar disesuaikan
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.05, left: screenWidth * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Daftar',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
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
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06), // Spasi dikurangi
                      Text(
                        '"Pengaduan warga menjadi\nmudah dan praktis."',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          color: Colors.white70,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bagian bawah dengan form register
          Expanded(
            // Gunakan Expanded agar bagian ini mengambil sisa ruang
            child: Container(
              width: screenWidth,
              color: Colors.white,
              // Padding vertikal dikurangi agar lebih compact
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.07,
                  vertical:
                      screenHeight * 0.02), // Padding vertikal lebih kecil
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Distribusi ruang antar elemen
                children: [
                  // Input NIK
                  _buildTextField(
                    context,
                    hintText: 'NIK',
                    icon: Icons.person,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _buildSpacer(screenHeight * 0.015), // Spacer lebih kecil

                  // Input Nama Lengkap
                  _buildTextField(
                    context,
                    hintText: 'Nama Lengkap',
                    icon: Icons.person,
                  ),
                  _buildSpacer(screenHeight * 0.015),

                  // Input No Whatsapp
                  _buildTextField(
                    context,
                    hintText: 'No Whatsapp',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _buildSpacer(screenHeight * 0.015),

                  // Input Password
                  _buildPasswordField(
                    context,
                    hintText: 'Password',
                    isVisible: _isPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  _buildSpacer(screenHeight * 0.015),

                  // Input Ulangi Password
                  _buildPasswordField(
                    context,
                    hintText: 'Ulangi Password',
                    isVisible: _isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  _buildSpacer(screenHeight * 0.025), // Spacer untuk tombol

                  // Tombol Daftar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Register
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // Padding vertikal tombol disesuaikan
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015),
                      ),
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _buildSpacer(screenHeight * 0.02), // Spacer untuk teks legal

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
                          const TextSpan(text: 'Dengan ini saya menyetujui\n'),
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
                  // _buildSpacer(screenHeight * 0.01), // Spacer di bagian paling bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk TextField umum
  Widget _buildTextField(
    BuildContext context, {
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height; // Untuk padding konten

    const Color accentBlue = Color(0xFF3F51B5);

    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: Colors.grey[600], fontSize: screenWidth * 0.04),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.grey, size: screenWidth * 0.06),
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
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, // Padding vertikal dikurangi
            horizontal: screenWidth * 0.03),
      ),
    );
  }

  // Helper method untuk PasswordField
  Widget _buildPasswordField(
    BuildContext context, {
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height; // Untuk padding konten

    const Color accentBlue = Color(0xFF3F51B5);

    return TextField(
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: Colors.grey[600], fontSize: screenWidth * 0.04),
        filled: true,
        fillColor: Colors.white,
        prefixIcon:
            Icon(Icons.lock, color: Colors.grey, size: screenWidth * 0.06),
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
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, // Padding vertikal dikurangi
            horizontal: screenWidth * 0.03),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: screenWidth * 0.06,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }

  // Helper method untuk SizedBox sebagai spacer
  Widget _buildSpacer(double height) {
    return SizedBox(height: height);
  }
}

// CustomClipper untuk membuat bentuk gelombang (tidak digunakan)
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

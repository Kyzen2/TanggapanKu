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
      home: const PengaduanPage(),
    );
  }
}

class PengaduanPage extends StatefulWidget {
  const PengaduanPage({super.key});

  @override
  State<PengaduanPage> createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  final TextEditingController _judulLaporanController = TextEditingController();
  final TextEditingController _kronologiController = TextEditingController();
  static const int _maxKronologiLength = 5000;

  @override
  void dispose() {
    _judulLaporanController.dispose();
    _kronologiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color accentBlue = Color(0xFF3F51B5);
    const Color lightGrey = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: primaryBlueDark,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: screenHeight * 0.035,
              width: screenHeight * 0.035,
              fit: BoxFit.contain,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'TanggapanKU',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none,
                color: Colors.white, size: screenWidth * 0.06),
            onPressed: () {
              // Handle notifikasi
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Pengaduan',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: primaryBlueDark,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Judul Laporan*',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: primaryBlueDark,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              context,
              controller: _judulLaporanController,
              hintText: 'Isi Judul Laporan Min 8 Karakter',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Kronologi Kejadian*',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: primaryBlueDark,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildMultiLineTextField(
              context,
              controller: _kronologiController,
              hintText: 'Jelaskan Kronologi Kejadian',
              maxLength: _maxKronologiLength,
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Data Lampiran',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: primaryBlueDark,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: () {
                print('Pilih Lampiran ditekan!');
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: Container(
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,
                          size: screenWidth * 0.08, color: Colors.grey[600]),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'Pilih Lampiran',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Judul: ${_judulLaporanController.text}');
                  print('Kronologi: ${_kronologiController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlueDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                child: Text(
                  'Kirim Laporan',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.04, color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
            color: Colors.grey[600], fontSize: screenWidth * 0.04),
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }

  Widget _buildMultiLineTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    int maxLength = 200,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return TextField(
      controller: controller,
      maxLines: 5,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
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
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        counterText: '${controller.text.length}/$maxLength',
      ),
    );
  }
}

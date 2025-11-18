import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/models/register.dart';
import 'package:tanggapanku/pages/region_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  int? _selectedRegion;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ApiServiceRegister _apiService = ApiServiceRegister();

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password tidak cocok dengan konfirmasi!')),
      );
      return;
    }
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      // Membuat objek Warga dengan data yang diinputkan oleh user
      Warga warga = Warga(
        nama: _namaController.text,
        noHp: _noHpController.text, // noHp tetap bertipe String
        nik: _nikController.text, // nik tetap bertipe String
        password: _passwordController.text,
        alamat: _alamatController.text,
        idDaerah: _selectedRegion,
      );

      // Membuat objek Register dengan data Warga dan ID Region
      Register registerData = Register(warga: warga);

      // Kirim data register ke API menggunakan fungsi registerUser
      final result = await _apiService.registerUser(registerData.toJson());

      Navigator.of(context).pop(); // Remove loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sukses'),
          content: Text(result['message'] ?? 'Registrasi Berhasil!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Remove loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header bagian atas
            Container(
              height: screenHeight * 0.35,
              width: screenWidth,
              color: const Color(0xFF2C3E50),
              child: Stack(
                children: [
                  Positioned(
                    bottom: -screenHeight * 0.05,
                    right: -screenWidth * 0.1,
                    child: Image.asset(
                      'assets/egi.png',
                      height: screenHeight * 0.50,
                      fit: BoxFit.fitHeight,
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
                            )
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
                        SizedBox(height: screenHeight * 0.02),
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
                  )
                ],
              ),
            ),

            // Form Input
            Container(
              width: screenWidth,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.07,
                  vertical: screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTextField(
                    context,
                    label: 'NIK',
                    icon: Icons.person,
                    controller: _nikController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    context,
                    label: 'Nama Lengkap',
                    icon: Icons.person,
                    controller: _namaController,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    context,
                    label: 'No Whatsapp',
                    icon: Icons.phone,
                    controller: _noHpController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildTextField(
                    context,
                    label: 'Alamat',
                    icon: Icons.location_on,
                    controller: _alamatController,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Tombol Pilih Region
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.map_outlined),
                      label: Text(
                        'Pilih Region',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3F51B5),
                        ),
                      ),
                      onPressed: () async {
                        final selectedRegion = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegionListPage(),
                          ),
                        );

                        if (selectedRegion != null) {
                          setState(() {
                            // Pastikan selectedRegion diubah menjadi integer sebelum disimpan
                            _selectedRegion =
                                selectedRegion; // Menggunakan integer langsung
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // Menampilkan region yang dipilih
                  if (_selectedRegion != null)
                    Text('ID Daerah yang dipilih: $_selectedRegion'),

                  _buildPasswordField(
                    context,
                    label: 'Password',
                    controller: _passwordController,
                    isVisible: _isPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildPasswordField(
                    context,
                    label: 'Ulangi Password',
                    controller: _confirmPasswordController,
                    isVisible: _isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk TextField
  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF3F51B5), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
      ),
    );
  }

  // Helper untuk Password Field
  Widget _buildPasswordField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: label,
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Color(0xFF3F51B5), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
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
}

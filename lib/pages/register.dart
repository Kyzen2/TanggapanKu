import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/pages/region_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  final _alamatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Selected region
  int? selectedRegionId;
  String? selectedRegionName;

  // Password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ApiService _api = ApiService();

  // Register handler
  Future<void> _handleRegister() async {
    if (selectedRegionId == null) {
      _showSnackbar("Pilih daerah dulu.");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackbar("Password tidak sama");
      return;
    }

    final data = {
      "id_daerah": selectedRegionId,
      "nama": _namaController.text,
      "no_hp": _noHpController.text,
      "nik": _nikController.text,
      "password": _passwordController.text,
      "alamat": _alamatController.text,
    };

    try {
      _showLoadingDialog();

      final res = await _api.registerUser(data);

      Navigator.of(context).pop(); // close loading

      _showSuccessDialog(res.message ?? "Registrasi berhasil");
    } catch (e) {
      Navigator.of(context).pop();
      print("ERROR = $e");
      _showSnackbar("Registrasi gagal: $e");
    }
  }

  // Helpers -----------------------------------------------------

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showSuccessDialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // UI ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color accentBlue = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: primaryBlueDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(w, h, primaryBlueDark),
            Container(
              width: w,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.07,
                vertical: h * 0.02,
              ),
              child: Column(
                children: [
                  _buildTextField('NIK', Icons.badge, _nikController),
                  SizedBox(height: h * 0.02),

                  _buildTextField(
                      'Nama Lengkap', Icons.person, _namaController),
                  SizedBox(height: h * 0.02),

                  _buildTextField(
                    'No Whatsapp',
                    Icons.phone,
                    _noHpController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: h * 0.02),

                  _buildTextField(
                      'Alamat', Icons.location_on, _alamatController),
                  SizedBox(height: h * 0.03),

                  // REGION PICKER BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.map_outlined),
                      label: Text(
                        selectedRegionName ?? 'Pilih Region',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: accentBlue,
                        ),
                      ),
                      onPressed: _pickRegion,
                    ),
                  ),

                  SizedBox(height: h * 0.03),

                  _buildPasswordField(
                    label: 'Password',
                    controller: _passwordController,
                    isVisible: _isPasswordVisible,
                    onToggleVisibility: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                  ),
                  SizedBox(height: h * 0.02),

                  _buildPasswordField(
                    label: 'Ulangi Password',
                    controller: _confirmPasswordController,
                    isVisible: _isConfirmPasswordVisible,
                    onToggleVisibility: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  SizedBox(height: h * 0.05),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        padding: EdgeInsets.symmetric(
                          vertical: h * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.poppins(
                          fontSize: w * 0.045,
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

  // PICK REGION -----------------------------------------------------

  Future<void> _pickRegion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegionListPage()),
    );

    if (result != null) {
      setState(() {
        selectedRegionId = result['id'];
        selectedRegionName = result['nama_daerah'];
      });
    }
  }

  // Header ----------------------------------------------------------

  Widget _buildHeader(double w, double h, Color bg) {
    return Container(
      height: h * 0.35,
      width: w,
      color: bg,
      child: Stack(
        children: [
          Positioned(
            bottom: -h * 0.16,
            right: -w * 0.07,
            child: Image.asset(
              'assets/egi.png',
              height: h * 0.65,
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: h * 0.08, left: w * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Daftar',
                      style: GoogleFonts.poppins(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: w * 0.02),
                    Image.asset(
                      'assets/logo.png',
                      height: w * 0.05,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Text(
                  'TanggapanKU',
                  style: GoogleFonts.poppins(
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: h * 0.05),
                Text(
                  '"Pengaduan warga menjadi\nmudah dan praktis."',
                  style: GoogleFonts.poppins(
                    fontSize: w * 0.035,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Text field reusable ----------------------------------------------

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Password field reusable ------------------------------------------

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

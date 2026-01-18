import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api_service.dart';
import '../models/warga.dart';

class ProfilePage extends StatefulWidget {
  final Warga user;
  final String token;

  const ProfilePage({
    super.key,
    required this.user,
    required this.token,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final purple = const Color(0xFF2E2A6A);
  

  // Controller
  late TextEditingController namaC;
  late TextEditingController emailC; // pake nik lu jadikan "email" UI
  late TextEditingController passwordC;
  late TextEditingController passwordBaruC;

  String? pickedFotoPath;

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.user.nama ?? '');
    emailC = TextEditingController(text: widget.user.nik);
    passwordC = TextEditingController();
    passwordBaruC = TextEditingController();
  }

  Future<void> pickFoto() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        pickedFotoPath = img.path;
      });
    }
  }

  Future<void> saveChanges() async {
    if (passwordC.text.isNotEmpty && passwordBaruC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru wajib diisi.")),
      );
      return;
    }

    final api = ApiService();

    final res = await api.updateProfile(
      token: widget.token,
      nama: namaC.text,
      noHp: widget.user.noHp,
      alamat: widget.user.alamat,
      password: passwordBaruC.text.isNotEmpty ? passwordBaruC.text : null,
      fotoPath: pickedFotoPath,
    );

    if (res["status"] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${res['body']['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: _BottomWaveClipper(),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [purple.withOpacity(0.9), purple],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: purple,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const Gap(30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 135,
                        height: 135,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: purple,
                          boxShadow: [
                            BoxShadow(
                              color: purple.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: purple, width: 3),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ],
                  ),
                  const Gap(30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: purple.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField('USERNAME', controller: namaC),
                        const Gap(14),
                        _buildField('E-mail',
                            controller: emailC, readOnly: true),
                        const Gap(14),
                        _buildField('PASSWORD',
                            controller: passwordC, obscure: true),
                        const Gap(14),
                        _buildField('PASSWORD BARU',
                            controller: passwordBaruC, obscure: true),
                        const Gap(25),
                        Center(
                          child: ElevatedButton(
                            onPressed: saveChanges,
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              minimumSize: const Size(180, 48),
                            ),
                            child: const Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? bgColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildField(String label,
      {bool obscure = false,
      TextEditingController? controller,
      bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Gap(6),
        TextField(
          controller: controller,
          obscureText: obscure,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            hintText:
                label == 'PASSWORD BARU' ? 'Masukkan password baru' : null,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF2E2A6A), width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 40);
    path.quadraticBezierTo(3 * size.width / 4, 80, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

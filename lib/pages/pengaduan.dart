import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaduanPage extends StatefulWidget {
  const PengaduanPage({super.key});

  @override
  State<PengaduanPage> createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  final TextEditingController _judul = TextEditingController();
  final TextEditingController _deskripsi = TextEditingController();
  final List<File> _selectedImages = [];

  bool _loading = false;

  @override
  void dispose() {
    _judul.dispose();
    _deskripsi.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Ambil dari Kamera"),
                onTap: () async {
                  Navigator.pop(context);
                  final photo =
                      await picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() => _selectedImages.add(File(photo.path)));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pilih dari Galeri"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await picker.pickMultiImage();
                  if (picked.isNotEmpty) {
                    setState(() {
                      _selectedImages.addAll(
                        picked.map((e) => File(e.path)),
                      );
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitPengaduan() async {
    if (_deskripsi.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kronologi terlalu pendek.")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Silakan login dulu.")),
        );
        return;
      }

      final api = ApiService();

      final res = await api.postPengaduan(
        token: token,
        judul: _judul.text,
        deskripsi: _deskripsi.text,
        fotoPaths: _selectedImages.map((e) => e.path).toList(),
      );

      if (res["status"] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengaduan berhasil dikirim!")),
        );

        _judul.clear();
        _deskripsi.clear();
        setState(() => _selectedImages.clear());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["body"]["message"] ?? "Gagal mengirim")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const primaryBlueDark = Color(0xFF2C3E50);
    const lightGrey = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 22,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              "TanggapanKU",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Judul Laporan*"),
            _buildTextField(_judul, "Isi Judul Laporan Min 8 Karakter"),
            const SizedBox(height: 20),
            const Text("Kronologi Kejadian*"),
            _buildTextField(_deskripsi, "Jelaskan Kronologi Kejadian",
                maxLines: 5),
            const SizedBox(height: 20),
            const Text("Lampiran Foto"),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ..._selectedImages.map(
                  (file) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      file,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2A6A),
                ),
                onPressed: _loading ? null : _submitPengaduan,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Laporan", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

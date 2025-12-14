import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/models/warga.dart';
import 'package:tanggapanku/pages/login.dart';
import 'package:tanggapanku/pages/profile_page.dart';
import 'package:tanggapanku/api/api_service.dart';

class AkunPage extends StatefulWidget {
  final Warga warga;

  const AkunPage({super.key, required this.warga});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString("token");

    if (savedToken == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
      return;
    }

    final api = ApiService();
    final res = await api.logoutUser(savedToken);

    await prefs.remove("token");

    if (res["status"] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil logout")),
      );
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C2C6B);

    if (token == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        title: Text(
          "TanggapanKU",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              backgroundImage: widget.warga.foto != null &&
                                      widget.warga.foto!.isNotEmpty
                                  ? NetworkImage(widget.warga.foto!)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.warga.nama ?? "Nama tidak tersedia",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "Alamat: ${widget.warga.alamat ?? '-'}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.phone, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              widget.warga.noHp ?? "-",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    user: widget.warga,
                                    token: token!,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Edit Profil",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E2A6A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 32),

            const Text(
              "Pengaturan",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            _menuItem(context, Icons.person, "Informasi Data Pribadi", () {}),
            _menuItem(context, Icons.notifications, "Penyesuaian Notifikasi", () {}),
            _menuItem(context, Icons.article, "Syarat dan Ketentuan Aplikasi", () {}),
            _menuItem(context, Icons.menu_book, "Panduan Penggunaan Aplikasi", () {}),
            _menuItem(context, Icons.help_outline, "Pertanyaan Umum", () {}),
            _menuItem(context, Icons.settings, "Pengaturan Lainnya", () {}),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Konfirmasi"),
                        content: const Text("Yakin mau logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              logout(context);
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  "Keluar",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        const SizedBox(height: 4),
        ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 32,
          dense: true,
          leading: Icon(icon, size: 22, color: Colors.black87),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: onTap,
        ),
        const Divider(thickness: 0.8, height: 1),
      ],
    );
  }
}

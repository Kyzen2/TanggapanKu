import 'package:flutter/material.dart';
import 'package:tanggapanku/pages/profile_page.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2C2C6B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === PROFILE CARD === //
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Wendy Haryadi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "ID Layanan: 2241237",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.phone, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "+62 817-2345-4998",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Disukai: 48   |   Kontribusi: 5",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 13),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () {},
                        child: GestureDetector(
                          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                            ),
                          );
                          },
                          child: const Text(
                          "Edit Profil",
                          style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Pengaturan",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            // === Menu Items === //
            _menuItem(Icons.person, "Informasi Data Pribadi"),
            _menuItem(Icons.notifications, "Penyesuaian Notifikasi"),
            _menuItem(Icons.article, "Syarat dan Ketentuan Aplikasi"),
            _menuItem(Icons.menu_book, "Panduan Penggunaan Aplikasi"),
            _menuItem(Icons.help_outline, "Pertanyaan Umum"),
            _menuItem(Icons.settings, "Pengaturan Lainnya"),

            const SizedBox(height: 20),

            // === Logout === //
            Center(
              child: GestureDetector(
                onTap: () {},
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

  Widget _menuItem(IconData icon, String title) {
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
          onTap: () {},
        ),
        Divider(thickness: 0.8, height: 1),
      ],
    );
  }
}

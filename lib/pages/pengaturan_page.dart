import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/models/warga.dart';
import 'package:tanggapanku/pages/login.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _hubungiKami() async {
    const phone = '628131128454';
    const message =
        'Halo Admin TanggapanKu, saya mau bertanya terkait aplikasi';

    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp tidak ditemukan')),
      );
    }
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
            _menuItem(
              context,
              Icons.article,
              "Syarat dan Ketentuan Aplikasi",
              () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return _syaratDanKetentuanSheet(context);
                  },
                );
              },
            ),
            _menuItem(
                context, Icons.menu_book, "Panduan Penggunaan Aplikasi", () {}),
            _menuItem(
              context,
              Icons.help_outline,
              "Pertanyaan Umum",
              () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _faqBottomSheet(context),
                );
              },
            ),

            _menuItem(
              context,
              Icons.support_agent,
              "Hubungi Kami",
              _hubungiKami,
            ),
            
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

// ================ SYARAT DAN KETENTUAN SHEET ==================
Widget _syaratDanKetentuanSheet(BuildContext context) {
  return FadeInUp(
    duration: const Duration(milliseconds: 400),
    child: DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const Gap(14),

              Text(
                "Syarat & Ketentuan Aplikasi",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Gap(12),

              /// ISI SYARAT (Markdown + scroll sinkron)
              Expanded(
                child: Markdown(
                  controller: scrollController,
                  data: _syaratMarkdown,
                  styleSheet: MarkdownStyleSheet(
                    p: GoogleFonts.poppins(fontSize: 13),
                    h3: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    listBullet: GoogleFonts.poppins(fontSize: 13),
                  ),
                ),
              ),

              const Gap(12),

              /// TOMBOL SETUJU
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Setuju & Lanjutkan",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

const String _syaratMarkdown = """
### 1. Ketentuan Umum
Dengan menggunakan aplikasi ini, pengguna dianggap telah membaca dan menyetujui seluruh ketentuan yang berlaku.

### 2. Akun & Keamanan
- Pengguna bertanggung jawab atas keamanan akun masing-masing  
- Dilarang membagikan informasi login kepada pihak lain  
- Aktivitas mencurigakan dapat menyebabkan pembatasan akun  

### 3. Privasi & Data
Kami menjaga data pribadi pengguna sesuai dengan kebijakan privasi:
- Data tidak diperjualbelikan  
- Data hanya digunakan untuk kebutuhan layanan  
- Pengguna berhak meminta penghapusan data  

### 4. Larangan Penggunaan
Pengguna **tidak diperkenankan**:
- Menyalahgunakan fitur aplikasi  
- Melakukan tindakan yang merugikan pihak lain  
- Menggunakan aplikasi untuk tujuan ilegal  

### 5. Perubahan Ketentuan
Syarat dan ketentuan dapat diperbarui sewaktu-waktu. Pengguna disarankan untuk memeriksa halaman ini secara berkala.

### 6. Penutup
Dengan menekan tombol **Setuju**, pengguna menyatakan sepakat tanpa paksaan dari pihak manapun.
""";
// ================ SYARAT DAN KETENTUAN SHEET ==================
// ================ PERTANYAAN UMUM SHEET ==================

Widget _faqBottomSheet(BuildContext context) {
  return FadeInUp(
    duration: const Duration(milliseconds: 400),
    child: DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const Gap(14),

              Text(
                "Pertanyaan Umum",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Gap(4),

              Text(
                "Seputar pengaduan dan keluhan warga",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const Gap(12),

              /// LIST FAQ
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _faqItem(
                      question: "Apa itu aplikasi TanggapanKu?",
                      answer:
                          "Aplikasi ini digunakan oleh warga untuk melaporkan permasalahan yang terjadi di lingkungan sekitar, seperti sampah menumpuk, jalan rusak, lampu mati, atau fasilitas umum lainnya.",
                    ),
                    _faqItem(
                      question: "Keluhan apa saja yang bisa dilaporkan?",
                      answer:
                          "Berbagai permasalahan di lapangan dapat dilaporkan, antara lain:\n"
                          "• Sampah menumpuk\n"
                          "• Jalan berlubang atau rusak\n"
                          "• Saluran air tersumbat\n"
                          "• Lampu penerangan mati\n"
                          "• Fasilitas umum rusak",
                    ),
                    _faqItem(
                      question: "Bagaimana cara mengirim pengaduan?",
                      answer:
                          "Pengguna dapat mengisi formulir pengaduan dengan menekan tombol + di tengah, dan menuliskan deskripsi masalah, serta melampirkan foto kondisi di lapangan agar laporan lebih akurat.",
                    ),
                    _faqItem(
                      question: "Apakah laporan saya akan ditindaklanjuti?",
                      answer:
                          "Setiap laporan yang masuk akan diverifikasi terlebih dahulu. Jika valid, laporan akan diteruskan kepada pihak terkait untuk ditindaklanjuti sesuai kewenangan.",
                    ),
                    _faqItem(
                      question: "Apakah identitas saya aman?",
                      answer:
                          "Ya. Identitas pelapor dijaga kerahasiaannya dan hanya digunakan untuk keperluan verifikasi laporan.",
                    ),
                    _faqItem(
                      question: "Berapa lama laporan diproses?",
                      answer:
                          "Waktu penanganan bergantung pada jenis dan tingkat urgensi laporan. Status laporan dapat dipantau langsung melalui aplikasi.",
                    ),
                  ],
                ),
              ),

              const Gap(12),

              /// BUTTON TUTUP
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Tutup",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _faqItem({
  required String question,
  required String answer,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ExpansionTile(
      title: Text(
        question,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      children: [
        Text(
          answer,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            color: Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}

// ================ PERTANYAAN UMUM SHEET ==================

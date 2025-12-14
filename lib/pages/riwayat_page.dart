import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/models/pengaduan.dart';
import 'package:tanggapanku/pages/detail_riwayat_pengaduan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPengaduanPage extends StatefulWidget {
  const RiwayatPengaduanPage({super.key});

  @override
  State<RiwayatPengaduanPage> createState() => _RiwayatPengaduanPageState();
}

class _RiwayatPengaduanPageState extends State<RiwayatPengaduanPage> {
  final api = ApiService();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color backgroundBlue = Color(0xFF39377C);
    const Color white = Colors.white;

    if (token == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: screenHeight * 0.032,
              width: screenHeight * 0.032,
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Riwayat ',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Pengaduan',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.06,
                      color: primaryBlueDark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: FutureBuilder<List<Pengaduan>>(
                future: api.fetchRiwayatPengaduan(token!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Belum ada pengaduan.'));
                  }

                  final pengaduanList = snapshot.data!;
                  return ListView.separated(
                    itemCount: pengaduanList.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: screenHeight * 0.01),
                    itemBuilder: (context, index) {
                      final p = pengaduanList[index];
                      final catatan = _getCatatanFromStatus(p.status);

                      return _buildPengaduanCard(
                        context,
                        judul: p.judul,
                        tanggal: p.tglPengaduan,
                        catatan: catatan,
                        status: p.status,
                        onPressed: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCatatanFromStatus(String status) {
    switch (status) {
      case 'Diajukan':
        return 'Sedang diajukan';
      case 'Diproses':
        return 'Sedang diproses';
      case 'Selesai':
        return 'Sudah selesai, terima kasih';
      case 'Ditolak':
        return 'Pengaduan ditolak';
      default:
        return '-';
    }
  }

  Widget _buildPengaduanCard(
    BuildContext context, {
    required String judul,
    required String tanggal,
    required String catatan,
    required String status,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey[700]),
                const SizedBox(width: 5),
                Text(
                  tanggal,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Catatan : $catatan',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailRiwayatPengaduanPage(),
                  ),
                );
              },
              child: Text(
                'Lihat Progress Laporan',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: const Color(0xFF39377C),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 7),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: status == 'Selesai'
                      ? const Color(0xFF2C3E50)
                      : const Color(0xFF39377C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.033,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

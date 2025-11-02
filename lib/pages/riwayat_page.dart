import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatPengaduanPage extends StatelessWidget {
  const RiwayatPengaduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color primaryBlueDark = Color(0xFF2C3E50);
    const Color backgroundBlue = Color(0xFF39377C);
    const Color white = Colors.white;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        title: Row(
          children: [
            // Ganti logo ini sesuai asset/logo kamu
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
            _buildPengaduanCard(
              context,
              judul: 'Laporan#223342 Lampu Mati Sebelah Mesjid As...',
              tanggal: '25 Okt 2025 09:55 PM',
              catatan: 'Belum ada',
              status: 'Peninjauan',
              onPressed: () {},
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildPengaduanCard(
              context,
              judul: 'Laporan#124742 Kehilangan 1 Unit Motor Honda V...',
              tanggal: '12 Apr 2025 12:23 PM',
              catatan: 'Kami sudah menindaklanjuti ...',
              status: 'Selesai',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
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
              'Catatan dari Petugas: $catatan',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            InkWell(
              onTap: () {}, // Tindakan klik
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

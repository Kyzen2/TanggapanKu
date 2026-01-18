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
  late Future<List<Pengaduan>> _futureRiwayat;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('token');

    if (t != null) {
      setState(() {
        token = t;
        _futureRiwayat = api.fetchRiwayatPengaduan(token!);
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureRiwayat = api.fetchRiwayatPengaduan(token!);
    });
    await _futureRiwayat;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      case 'Diproses':
        return Colors.orange;
      case 'Diajukan':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (token == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/Logo.png',
              height: screenHeight * 0.032,
              width: screenHeight * 0.032,
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
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: FutureBuilder<List<Pengaduan>>(
                future: _futureRiwayat,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(child: Text('Belum ada pengaduan.')),
                        ],
                      ),
                    );
                  }

                  final list = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: screenHeight * 0.01),
                      itemBuilder: (context, index) {
                        final p = list[index];
                        return _buildPengaduanCard(
                          context,
                          pengaduan: p,
                          statusColor: _statusColor(p.status),
                          catatan: _getCatatanFromStatus(p.status),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengaduanCard(
    BuildContext context, {
    required Pengaduan pengaduan,
    required Color statusColor,
    required String catatan,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pengaduan.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  pengaduan.tglPengaduan,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Catatan : $catatan',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DetailRiwayatPengaduanPage(pengaduan: pengaduan),
                  ),
                );
                _refreshData();
              },
              child: Text(
                'Lihat Progress Laporan',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: const Color(0xFF39377C),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pengaduan.status,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.033,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

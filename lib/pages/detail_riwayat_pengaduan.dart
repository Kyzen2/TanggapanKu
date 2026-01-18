import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:tanggapanku/models/pengaduan.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRiwayatPengaduanPage extends StatefulWidget {
  final Pengaduan pengaduan;

  const DetailRiwayatPengaduanPage({
    super.key,
    required this.pengaduan,
  });

  @override
  State<DetailRiwayatPengaduanPage> createState() =>
      _DetailRiwayatPengaduanPageState();
}

class _DetailRiwayatPengaduanPageState
    extends State<DetailRiwayatPengaduanPage> {
  final PageController _pageController = PageController();

  late final List<String> images;
  String? namaWarga;

  @override
  void initState() {
    super.initState();
    _loadUser();

    images = widget.pengaduan.foto
        .where((e) => e.pathFoto.isNotEmpty)
        .map((e) => 'https://firmly-splendid-dove.ngrok-free.app/${e.pathFoto}')
        .toList();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');

    if (userStr != null) {
      final user = jsonDecode(userStr);
      setState(() {
        namaWarga = user['nama']; // sesuaikan key kalau beda
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pengaduan = widget.pengaduan;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        title: Text(
          'Detail Pengaduan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _pengaduanCard(pengaduan),
            const Spacer(),
            _backButton(),
          ],
        ),
      ),
    );
  }

  Widget _pengaduanCard(Pengaduan p) {
    final tanggal = DateTime.tryParse(p.tglPengaduan);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userHeader(),
          const SizedBox(height: 12),

          /// JUDUL
          Text(
            p.judul,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 6),

          /// DESKRIPSI
          Text(
            p.deskripsi,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 12),

          /// FOTO
          if (images.isNotEmpty) _imageSlider(),

          const SizedBox(height: 12),

          /// FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tanggal != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(tanggal)
                    : '-',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              _statusBadge(p.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _userHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF2E2A6A),
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          namaWarga ?? 'Warga',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _imageSlider() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: images.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Color(0xFF2E2A6A),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'Selesai':
        color = Colors.green;
        break;
      case 'Ditolak':
        color = Colors.red;
        break;
      case 'Diproses':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _backButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E2A6A),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Kembali',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

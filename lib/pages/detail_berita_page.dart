import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tanggapanku/models/berita.dart';

class DetailBeritaPage extends StatelessWidget {
  final Berita berita;

  const DetailBeritaPage({
    super.key,
    required this.berita,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        elevation: 0,
        title: Text(
          'Detail Berita',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _beritaCard(),
      ),
    );
  }

  Widget _beritaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _authorHeader(),
          const SizedBox(height: 12),

          /// BADGE KATEGORI
          _categoryBadge(berita.kategori),
          const SizedBox(height: 12),

          /// JUDUL
          Text(
            berita.judul,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          /// TANGGAL
          Text(
            _formatTanggal(berita.tglTerbit),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 16),

          /// GAMBAR
          if (berita.foto != null) _imageSingle(berita.foto!),

          const SizedBox(height: 16),

          /// DESKRIPSI
          Text(
            berita.deskripsi ?? '-',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _authorHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF2E2A6A),
          child: Icon(Icons.newspaper, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          'Admin',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _imageSingle(String imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image)),
        ),
      ),
    );
  }

  Widget _categoryBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2A6A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTanggal(String rawDate) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(rawDate));
    } catch (_) {
      return '-';
    }
  }
}

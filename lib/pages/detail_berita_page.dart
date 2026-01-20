import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailBeritaPage extends StatefulWidget {
  const DetailBeritaPage({super.key});

  @override
  State<DetailBeritaPage> createState() => _DetailBeritaPageState();
}

class _DetailBeritaPageState extends State<DetailBeritaPage> {
  final String imageUrl = 'https://picsum.photos/800/400';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _beritaCard(),
            const Spacer(),
          ],
        ),
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _authorHeader(),
          const SizedBox(height: 12),

          /// JUDUL
          Text(
            'Kerja Bakti Warga Membersihkan Lingkungan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          /// ISI BERITA
          Text(
            'Warga RT 05 melakukan kerja bakti bersama untuk membersihkan '
            'saluran air dan lingkungan sekitar demi menjaga kebersihan '
            'dan kesehatan bersama.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),

          const SizedBox(height: 12),

          /// GAMBAR BERITA (SINGLE)
          _imageSingle(),

          const SizedBox(height: 12),

          /// FOOTER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
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
          'Admin Desa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _imageSingle() {
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
}

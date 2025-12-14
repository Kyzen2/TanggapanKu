import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class DetailRiwayatPengaduanPage extends StatefulWidget {
  const DetailRiwayatPengaduanPage({super.key});

  @override
  State<DetailRiwayatPengaduanPage> createState() => _RiwayatPengaduanPageState();
}

class _RiwayatPengaduanPageState extends State<DetailRiwayatPengaduanPage> {
  final PageController _pageController = PageController();
  final List<String> images = [
    'https://i.imgur.com/7RrX4Yv.png',
    'https://i.imgur.com/7RrX4Yv.png',
    'https://i.imgur.com/7RrX4Yv.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2A6A),
        title: Text(
          'Riwayat Pengaduan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _pengaduanCard(),
            const Spacer(),
            _backButton(),
          ],
        ),
      ),
    );
  }

  Widget _pengaduanCard() {
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
          Text(
            'Game Roblox mengubah IQ anak anak indonesia',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '24 Oktober 2025 - Polisi berhasil mengungkap kasus pengaduan terhadap anak di bawah umur yang terjadi di wilayah Mc Gacoan, Kota Cianjur, Kecamatan Cianjur.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          _imageSlider(),
          const SizedBox(height: 12),
          _footer(),
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
          'Wendy Haryadi',
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
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: _pageController,
          count: images.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: const Color(0xFF2E2A6A),
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('dd MMM yyyy, HH:mm')
              .format(DateTime(2025, 10, 25, 17, 53)),
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Peninjauan',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
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
        onPressed: () {
          Navigator.pop(context);
        },
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

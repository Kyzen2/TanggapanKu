import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tanggapanku/pages/pengaduan.dart';

class FloatingNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Future<void> _openWhatsApp(BuildContext context) async {
    const phone = '628131128454'; // ganti kalau perlu
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black12, width: 0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home_rounded, 0),

          // CHAT → LANGSUNG WA
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _openWhatsApp(context),
            child: _navItemContent(
              icon: Icons.chat_bubble_outline_rounded,
              label: "Chat",
              selected: false,
            ),
          ),

          // ADD PENGADUAN
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PengaduanPage(),
                ),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF2E2A6A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),

          _buildNavItem(context, Icons.history, 3),
          _buildNavItem(context, Icons.person_outline_rounded, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => onTap(index),
      child: _navItemContent(
        icon: icon,
        label: _getLabel(index),
        selected: isSelected,
      ),
    );
  }

  Widget _navItemContent({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: selected ? const Color(0xFF7D54DF) : Colors.grey,
          size: selected ? 28 : 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? const Color(0xFF7D54DF) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

String _getLabel(int index) {
  switch (index) {
    case 0:
      return "Beranda";
    case 3:
      return "Riwayat";
    case 4:
      return "Profil";
    default:
      return "";
  }
}

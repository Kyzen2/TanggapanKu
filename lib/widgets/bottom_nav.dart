import 'package:flutter/material.dart';
import 'package:tanggapanku/pages/pengaduan.dart';


class FloatingNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Colors.black12, width: 0.6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.chat_bubble_outline_rounded, 1),

          // tombol add tetap ada, tapi gak ngambang
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengaduanPage(),
                ),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF7D54DF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),


          _buildNavItem(Icons.history, 3),
          _buildNavItem(Icons.person_outline_rounded, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF7D54DF) : Colors.grey,
            size: isSelected ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Text(
            _getLabel(index),
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? const Color(0xFF7D54DF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

String _getLabel(int index) {
  switch (index) {
    case 0:
      return "Beranda";
    case 1:
      return "Chat";
    case 2:
      return "Pengaduan";
    case 3:
      return "Riwayat";
    case 4:
      return "Profil";
    default:
      return "";
  }
}

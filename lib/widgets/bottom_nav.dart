import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FloatingNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNav> createState() => _FloatingNavState();
}
String _getLabel(int index) {
  switch (index) {
    case 0:
      return "Beranda";
    case 1:
      return "Chat";
    case 3:
      return "Notif";
    case 4:
      return "Profil";
    default:
      return "";
  }
}


class _FloatingNavState extends State<FloatingNav> {
  bool _navVisible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      offset: _navVisible ? Offset.zero : const Offset(0, 1.5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        height: 70,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, 0),
            _buildNavItem(Icons.chat_bubble_outline_rounded, 1),

            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFF7D54DF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7D54DF).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),

            _buildNavItem(Icons.notifications_none_rounded, 3),
            _buildNavItem(Icons.person_outline_rounded, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
  final isSelected = widget.currentIndex == index;
  return InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: () => widget.onTap(index),
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



  //fungsi kontrol hide/show nav dari luar
  void setVisibility(bool visible) {
    if (visible != _navVisible) {
      setState(() => _navVisible = visible);
    }
  }
}

import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF00B6A0),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), label: ''),
      ],
    );
  }
}

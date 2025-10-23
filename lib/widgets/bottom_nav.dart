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
      selectedItemColor: const Color(0xFF7D54DF),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_rounded),
          label: '',
        ),

        BottomNavigationBarItem(
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF7D54DF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
          label: '',
        ),

        const BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_rounded),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: '',
        ),
      ],
    );
  }
}

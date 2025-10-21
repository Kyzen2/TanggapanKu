import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=10'),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF00B6A0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.ac_unit, color: Colors.white, size: 18),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

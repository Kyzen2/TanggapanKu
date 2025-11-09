import 'package:flutter/material.dart';
// import '../pages/profile_page.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    // sementara nama user hardcode
    final String userName = "Muhamad Nabil Nur Praja";

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Row(
        children: [
          // FOTO PROFIL
          InkWell(
            borderRadius: BorderRadius.circular(20),
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=10'),
            ),
          ),

          const SizedBox(width: 12),

          // TEKS WELCOME + NAMA USER
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ICON 1
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF00B6A0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.ac_unit, color: Colors.white, size: 18),
          ),

          const SizedBox(width: 10),

          // ICON SETTINGS
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active, color: Color(0xFF7D54DF)),
          ),
        ],
      ),
    );
  }
}

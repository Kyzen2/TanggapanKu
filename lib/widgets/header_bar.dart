import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String userName; // Nama user yang dikirim dari halaman sebelumnya
  final String? profileImageUrl; // Optional: URL foto profil user

  const HeaderBar({
    super.key,
    required this.userName,
    this.profileImageUrl, // default null, kalau null pakai avatar placeholder
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              // TODO: buka halaman profile
            },
            child: CircleAvatar(
              radius: 23,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : const NetworkImage('https://i.pravatar.cc/100?img=10'),
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

          // ICON 1 (Contoh bisa diganti)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF00B6A0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.ac_unit, color: Colors.white, size: 18),
          ),

          const SizedBox(width: 10),

          // ICON NOTIFICATION / SETTINGS
          IconButton(
            onPressed: () {
              // TODO: handle notifikasi
            },
            icon: const Icon(Icons.notifications_active,
                color: Color(0xFF7D54DF)),
          ),
        ],
      ),
    );
  }
}

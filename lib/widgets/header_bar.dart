import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            child: const CircleAvatar(
              radius: 23,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 26,
              ),
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

          Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),


          const SizedBox(width: 10),

          // ICON NOTIFICATION / SETTINGS
          Row(
            children: [
              const Icon(Icons.circle, color: Colors.green, size: 10),
              const SizedBox(width: 4),
              Text(
                "Layanan Aktif",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

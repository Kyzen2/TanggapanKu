import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tanggapanku/models/post.dart';

class DetailPostingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String date;

  const DetailPostingPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF4047EB);

    // Convert date string ke DateTime
    final DateTime parsedDate = DateTime.tryParse(date) ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Postingan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TITLE & CATEGORY
          Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Kategori: ${category.toUpperCase()} · ${timeago.format(parsedDate, locale: 'id')}",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // DESCRIPTION
          Text(
            description,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(fontSize: 15),
          ),

          const SizedBox(height: 25),
          const Divider(),

          // COMMENTS TITLE
          Text("Komentar",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600)),

          const SizedBox(height: 12),

          // EXAMPLE COMMENT
          _buildComment(
            name: "Sinta Ningsih",
            comment: "Ya Allah.. jauhkan keluarga hamba dari orang dzolim...",
            time: DateTime.now().subtract(const Duration(minutes: 15)),
          ),

          const SizedBox(height: 10),

          _buildComment(
            name: "Dani Pratama",
            comment: "Semoga pelaku dihukum seberat-beratnya.",
            time: DateTime.now().subtract(const Duration(hours: 3)),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // INPUT COMMENT
          Text("Tulis Komentar",
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500)),

          const SizedBox(height: 8),

          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Tulis komentar...",
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Kirim",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComment(
      {required String name, required String comment, required DateTime time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/100")),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Text(comment, style: GoogleFonts.poppins()),
              const SizedBox(height: 4),
              Text(timeago.format(time, locale: "id"),
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }
}

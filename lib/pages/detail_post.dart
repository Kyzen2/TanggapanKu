import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPostingPage extends StatelessWidget {
  final String authorName;
  final String authorRole;
  final DateTime date;
  final String content;
  final String imageUrl;

  const DetailPostingPage({
    super.key,
    required this.authorName,
    required this.authorRole,
    required this.date,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF4047EB);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 6),
            Text(
              "Detail Postingan",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // PROFILE HEADER
          Row(
            children: [
              const CircleAvatar(
                radius: 23,
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/100?img=12"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName,
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(authorRole,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Text(timeago.format(date, locale: "id"),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 18),

          // CONTENT
          Text(
            content,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(fontSize: 15),
          ),

          const SizedBox(height: 16),

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(imageUrl),
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

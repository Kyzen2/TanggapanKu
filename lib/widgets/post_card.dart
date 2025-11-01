import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/post.dart';
import '../pages/detail_post.dart'; // <-- Tambahin ini

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👇 Arahkan ke halaman detail saat card diklik
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPostingPage(
              authorName: post.name, // Sesuai model kamu
              authorRole: post.handle, // Bisa "Staff" / Pegawai / etc
              date: DateTime.now(), // Kalau di model ada date, pake itu
              content: post.text,
              imageUrl: post.imageUrl,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.black.withOpacity(0.08),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO KIRI
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                post.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),

            const Gap(12),

            // BAGIAN KANAN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${post.handle}  ${post.name}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    post.text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(6),
                  Text(
                    "Posted · ${post.comments} comments · ${post.likes} likes",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border, size: 20),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.comment_outlined, size: 20),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: const Icon(Icons.share, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/post.dart';
import '../pages/detail_post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Base URL untuk gambar dari API
    const String baseUrl = "https://firmly-splendid-dove.ngrok-free.app/";

    // Cek URL gambar, pakai placeholder kalau kosong
    final String imageUrl = (post.imageUrl.isNotEmpty)
        ? (post.imageUrl.startsWith("http")
            ? post.imageUrl
            : baseUrl + post.imageUrl)
        : "https://via.placeholder.com/85";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPostingPage(
              title: post.title,
              description: post.description,
              imageUrl: imageUrl,
              category: post.category,
              date: post.date,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
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
                imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 85,
                  height: 85,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            const Gap(12),

            // BAGIAN KANAN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Text(
                    post.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(6),
                  Text(
                    "Category: ${post.category} · ${post.date}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

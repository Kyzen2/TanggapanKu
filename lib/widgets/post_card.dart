import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
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

          // BAGIAN KANAN (Expanded agar fleksibel)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAMA + HANDLE
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

                // DESKRIPSI / TEXT
                Text(
                  post.text,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Gap(6),

                // TANGGAL atau INFO LAIN
                Text(
                  "Posted · ${post.comments} comments · ${post.likes} likes",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),

                const Gap(8),

                // TOMBOL LIKE - COMMENT - SHARE
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
    );
  }
}

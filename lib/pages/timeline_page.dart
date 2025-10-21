import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/post.dart';
import '../widgets/header_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _selectedIndex = 0;

  final List<Post> posts = [
    Post(
      name: 'Futaba',
      handle: '@R_Futaba',
      text: 'This is my Husband',
      avatarUrl: 'https://i.pravatar.cc/100?img=5',
      imageUrl: 'https://picsum.photos/seed/p1/600/360',
      comments: 12000,
      likes: 10000,
    ),
    Post(
      name: 'Vergil',
      handle: '@V_TheDevil',
      text: 'Wanted, stupid child lost',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
      imageUrl: 'https://picsum.photos/seed/p2/600/360',
      comments: 320,
      likes: 1000,
    ),
    Post(
      name: 'Sahronu',
      handle: '@S_Roniloni',
      text: 'Sembunyi di kamar mandi cek!',
      avatarUrl: 'https://i.pravatar.cc/100?img=22',
      imageUrl: 'https://picsum.photos/seed/p3/600/360',
      comments: 45,
      likes: 210,
    ),
  ];

  void _onNavTap(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (_, __) => const Gap(8),
                itemCount: posts.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: PostCard(post: posts[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

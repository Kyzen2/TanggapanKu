import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _navVisible = true;

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
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_navVisible) setState(() => _navVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_navVisible) setState(() => _navVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sliderImages = [
      'https://picsum.photos/seed/p4/600/360',
      'https://picsum.photos/seed/p5/600/360',
      'https://picsum.photos/seed/p1/600/360',
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Konten utama scrollable
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(child: HeaderBar()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                      ),
                      items: sliderImages.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(image, fit: BoxFit.cover),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // 🔹 Post list
                
                // 🔹 Judul berita
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      "Berita Terbaru",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 🔹 Post list
                SliverList.separated(
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const Gap(8),
                  itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: PostCard(post: posts[index]),
                  ),
                ),


                // 🔹 sedikit ruang di bawah biar tidak ketutupan navbar
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // 🔹 Navbar animasi (ngambang di atas konten)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              offset: _navVisible ? Offset.zero : const Offset(0, 1.4),
              curve: Curves.easeInOutCubicEmphasized,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _navVisible ? 1 : 0,
                child: FloatingNav(
                  currentIndex: _selectedIndex,
                  onTap: _onNavTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

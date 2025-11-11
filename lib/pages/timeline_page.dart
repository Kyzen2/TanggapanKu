import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:tanggapanku/pages/riwayat_page.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../models/post.dart';
import '../widgets/header_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav.dart';
import 'pengaduan.dart';
import 'pengaturan_page.dart';
import 'register.dart';

class TimelinePage extends StatefulWidget {
  final bool startTutorial;
  const TimelinePage({super.key, this.startTutorial = false});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _selectedIndex = 0;
  bool _navVisible = true;
  final ScrollController _scrollController = ScrollController();

  /// Tambahkan global key untuk tutorial
  final GlobalKey keyCarousel = GlobalKey();
  final GlobalKey keyNavBar = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

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
    if (widget.startTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTutorial();
      });
    }
  }

  void showTutorial() {
    targets = [
      TargetFocus(
        identify: "Carousel",
        keyTarget: keyCarousel,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Panduan Slider Utama",
                      style: TextStyle(
                        color: Color(0xFF2C2C6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Slide ini menampilkan berita-berita utama dan pengumuman penting. Geser ke kiri atau kanan untuk melihat lebih banyak informasi.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "NavBar",
        keyTarget: keyNavBar,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.82,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Navigation Bar",
                      style: TextStyle(
                        color: Color(0xFF2C2C6B),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Gunakan tombol bawah ini untuk berpindah halaman dengan cepat: Home, Pengaduan, Register, Riwayat, dan Akun.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.6),
      paddingFocus: 10,
      textSkip: "Lewati",
      onFinish: () {},
      onSkip: () { return true; },
    );
    tutorialCoachMark?.show(context: context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pages.isEmpty) {
      _pages.addAll([
        TimelinePageContent(
            keyCarousel: keyCarousel, scrollController: _scrollController),
        const PengaduanPage(),
        const RegisterPage(),
        const RiwayatPengaduanPage(),
        const AkunPage(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedSlide(
        key: keyNavBar, // Tambahkan global key di nav
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
    );
  }
}

// Widget untuk isi halaman timeline
class TimelinePageContent extends StatelessWidget {
  final GlobalKey keyCarousel;
  final ScrollController scrollController;
  TimelinePageContent(
      {super.key, required this.keyCarousel, required this.scrollController});

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

  final List<String> sliderImages = [
    'https://picsum.photos/seed/p4/600/360',
    'https://picsum.photos/seed/p5/600/360',
    'https://picsum.photos/seed/p1/600/360',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverToBoxAdapter(child: HeaderBar()),

          // carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CarouselSlider(
                key: keyCarousel, // pasang key tutorial
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
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

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                "Berita Terbaru",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverList.separated(
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: PostCard(post: posts[index]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:tanggapanku/pages/riwayat_page.dart';
import 'package:tanggapanku/services/berita_services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../models/post.dart';
import '../widgets/header_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/bottom_nav.dart';
import 'pengaduan.dart';
import 'pengaturan_page.dart';
import 'register.dart';
// import 'riwayat_page.dart';

class TimelinePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String token;

  final bool startTutorial;
  const TimelinePage({super.key, this.startTutorial = false, this.userData = const {}, required this.token });

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      TimelinePageContent(userName: widget.userData['nama'] ?? 'User', keyCarousel: keyCarousel, scrollController: _scrollController,
        token: widget.token,
      ), // kirim nama user
      const PengaduanPage(),
      const RegisterPage(),
      const RiwayatPengaduanPage(),
      const AkunPage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _navVisible ? Offset.zero : const Offset(0, 1.4),
        curve: Curves.easeInOutCubicEmphasized,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _navVisible ? 1 : 0,
          child: FloatingNav(
            key: keyNavBar, // ← WAJIB dipasang!
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
          ),

        ),
      ),
    );
  }
}

// Widget untuk isi halaman timeline
class TimelinePageContent extends StatefulWidget {
  final String userName;
  final GlobalKey keyCarousel;
  final ScrollController scrollController;
  final String token;

  const TimelinePageContent({
    super.key,
    required this.keyCarousel,
    required this.scrollController,
    required this.userName,
    required this.token,
  });

  @override
  State<TimelinePageContent> createState() => _TimelinePageContentState();
}

class _TimelinePageContentState extends State<TimelinePageContent> {
  List<Post> carouselPosts = [];
  List<Post> generalPosts = [];
  bool isLoading = true;

  final TimelineService timelineService = TimelineService();
  late String token;

  @override
  void initState() {
    super.initState();
    token = widget.token;
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    setState(() => isLoading = true);

    try {
      final List<Post> response = await timelineService.getBerita(token);

      final List<Post> bantuan = [];
      final List<Post> umum = [];

      for (var post in response) {
        if (post.category.toLowerCase() == 'bantuan') {
          bantuan.add(post);
        } else {
          umum.add(post);
        }
      }

      setState(() {
        carouselPosts = bantuan;
        generalPosts = umum;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetch berita: $e");
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HeaderBar(userName: widget.userName),
          ),

          // Carousel Bantuan
          if (carouselPosts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CarouselSlider(
                  key: widget.keyCarousel,
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                  ),
                  items: carouselPosts.map((post) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(post.imageUrl, fit: BoxFit.cover),
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

          // Berita Umum
          if (generalPosts.isNotEmpty)
            SliverList.separated(
              itemCount: generalPosts.length,
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: PostCard(post: generalPosts[index]),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

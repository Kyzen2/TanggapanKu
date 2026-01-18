import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gap/gap.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/models/berita.dart';
import 'package:tanggapanku/models/warga.dart';
import '../widgets/header_bar.dart';
import '../widgets/bottom_nav.dart';
import 'pengaduan.dart';
import 'pengaturan_page.dart';
import 'register.dart';
import 'riwayat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimelinePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final bool startTutorial;

  const TimelinePage({
    super.key,
    this.startTutorial = false,
    required this.userData,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _selectedIndex = 0;
  bool _navVisible = true;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey keyCarousel = GlobalKey();
  final GlobalKey keyNavBar = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  List<Berita> beritaBantuan = [];
  List<Berita> beritaUmum = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();

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

  Future<void> fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint("Token ga ketemu, user belum login");
        return;
      }

      final api = ApiService();
      final allNews = await api.fetchBeritaByDaerah(token);

      beritaBantuan = allNews.where((b) => b.kategori == "Bantuan").toList();
      beritaUmum = allNews.where((b) => b.kategori == "umum").toList();
    } catch (e) {
      debugPrint("Error load berita: $e");
    }

    if (mounted) {
      setState(() => loading = false);
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
            builder: (context, controller) => tutorialBox(
              title: "Panduan Slider Utama",
              text:
                  "Slide ini menampilkan berita-berita utama dan pengumuman penting.",
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
            builder: (context, controller) => tutorialBox(
              title: "Navigation Bar",
              text:
                  "Gunakan tombol bawah ini untuk berpindah halaman dengan cepat.",
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
    );
    tutorialCoachMark?.show(context: context);
  }

  Widget tutorialBox({required String title, required String text}) {
    return Center(
      child: Container(
        width: 280,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Color(0xFF2C2C6B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            const SizedBox(height: 8),
            Text(text,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TimelinePageContent(
        userName: widget.userData['nama'],
        keyCarousel: keyCarousel,
        scrollController: _scrollController,
        loading: loading,
        sliderItems: beritaBantuan,
        beritaList: beritaUmum,
      ),
      const PengaduanPage(),
      const RegisterPage(),
      const RiwayatPengaduanPage(),
      AkunPage(
        warga: Warga.fromJson(widget.userData)
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _navVisible ? Offset.zero : const Offset(0, 1.4),
        curve: Curves.easeInOutCubicEmphasized,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _navVisible ? 1 : 0,
          child: FloatingNav(
            key: keyNavBar,
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
          ),
        ),
      ),
    );
  }
}

class TimelinePageContent extends StatelessWidget {
  final String userName;
  final GlobalKey keyCarousel;
  final ScrollController scrollController;

  final bool loading;
  final List<Berita> sliderItems; // berita bantuan
  final List<Berita> beritaList; // berita umum

  const TimelinePageContent({
    super.key,
    required this.userName,
    required this.keyCarousel,
    required this.scrollController,
    required this.loading,
    required this.sliderItems,
    required this.beritaList,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(child: HeaderBar(userName: userName)),

          // SLIDER ATAS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : CarouselSlider(
                      key: keyCarousel,
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                      ),
                      items: sliderItems.isEmpty
                          ? [
                              Container(
                                alignment: Alignment.center,
                                child: const Text("Tidak ada berita bantuan"),
                              )
                            ]
                          : sliderItems.map((b) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    b.foto != null
                                        ? Image.network(
                                            b.foto!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(color: Colors.grey),
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
                                    Positioned(
                                      bottom: 12,
                                      left: 12,
                                      right: 12,
                                      child: Text(
                                        b.judul,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // LIST BERITA UMUM
          loading
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              : SliverList.separated(
                  itemCount: beritaList.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (context, index) {
                    final b = beritaList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (b.foto != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14)),
                                child: Image.network(
                                  b.foto!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                b.judul,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

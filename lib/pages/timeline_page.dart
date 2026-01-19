import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/models/region.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/models/berita.dart';
import 'package:tanggapanku/models/warga.dart';
import '../widgets/header_bar.dart';
import '../widgets/bottom_nav.dart';
import 'pengaduan.dart';
import 'pengaturan_page.dart';
import 'register.dart';
import 'riwayat_page.dart';

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

  List<Berita> beritaBantuan = [];
  List<Berita> beritaUmum = [];
  bool loading = true;

  // === tambahan untuk WA dan daerahUser ===
  Daerah? _daerahUser;

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadDaerahUser();

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

  Future<void> fetchData() async {
    setState(() => loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final api = ApiService();
      final allNews = await api.fetchBeritaByDaerah(token);

      beritaBantuan = allNews.where((b) => b.kategori == "Bantuan").toList();
      beritaUmum = allNews.where((b) => b.kategori == "umum").toList();
    } catch (e) {
      debugPrint("Error load berita: $e");
    }

    if (mounted) setState(() => loading = false);
  }

  Future<void> _loadDaerahUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      try {
        final api = ApiService();
        final data = await api.fetchDaerahUser(token);
        if (mounted) setState(() => _daerahUser = data);
      } catch (e) {
        debugPrint("Gagal fetch daerahUser: $e");
      }
    }
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _openWhatsApp() async {
    if (_daerahUser == null || _daerahUser!.noTelp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp belum tersedia')),
      );
      return;
    }

    String phone = _daerahUser!.noTelp;
    if (phone.startsWith('0')) phone = '62${phone.substring(1)}';

    const message = 'Halo saya ingin mengecek pengaduan saya';
    final url =
        Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp tidak ditemukan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TimelinePageContent(
        userName: widget.userData['nama'],
        keyCarousel: keyCarousel,
        scrollController: _scrollController,
        loading: loading,
        sliderItems: beritaBantuan,
        beritaList: beritaUmum,
        onRefresh: fetchData,
      ),
      const PengaduanPage(),
      const RegisterPage(),
      const RiwayatPengaduanPage(),
      AkunPage(warga: Warga.fromJson(widget.userData)),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _navVisible ? Offset.zero : const Offset(0, 1.4),
        child: FloatingNav(
          key: keyNavBar,
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          daerahUser: _daerahUser, // <-- kirim data daerahUser ke nav
          openWhatsApp: _openWhatsApp, // <-- optional callback WA
        ),
      ),
    );
  }
}

// === TimelinePageContent tetap sama ===
class TimelinePageContent extends StatelessWidget {
  final String userName;
  final GlobalKey keyCarousel;
  final ScrollController scrollController;
  final bool loading;
  final List<Berita> sliderItems;
  final List<Berita> beritaList;
  final Future<void> Function() onRefresh;

  const TimelinePageContent({
    super.key,
    required this.userName,
    required this.keyCarousel,
    required this.scrollController,
    required this.loading,
    required this.sliderItems,
    required this.beritaList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: const Color(0xFF2E2A6A),
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(child: HeaderBar(userName: userName)),

            // Slider atau teks "Tidak ada berita bantuan"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : (sliderItems.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Tidak ada berita bantuan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : CarouselSlider(
                            key: keyCarousel,
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                            ),
                            items: sliderItems.map((b) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      b.foto ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 12,
                                      right: 12,
                                      bottom: 12,
                                      child: Text(
                                        b.judul,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )),
              ),
            ),

            // Label Berita Terbaru
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Berita Terbaru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Daftar berita umum
            loading
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SliverList.builder(
                    itemCount: beritaList.length,
                    itemBuilder: (context, index) {
                      final b = beritaList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: Card(
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

            // Spacer bawah
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

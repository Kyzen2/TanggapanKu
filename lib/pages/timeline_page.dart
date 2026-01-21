import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanggapanku/models/region.dart';
import 'package:tanggapanku/pages/detail_berita_page.dart';
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

  const TimelinePage({
    super.key,
    required this.userData,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  int _selectedIndex = 0;
  bool _navVisible = true;
  final ScrollController _scrollController = ScrollController();

  List<Berita> beritaBantuan = [];
  List<Berita> beritaUmum = [];
  bool loading = true;

  Daerah? _daerahUser;

  @override
  void initState() {
    super.initState();
    fetchData();
    _loadDaerahUser();

    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse && _navVisible) {
        setState(() => _navVisible = false);
      } else if (direction == ScrollDirection.forward && !_navVisible) {
        setState(() => _navVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ===================== WHATSAPP ADMIN =====================
  Future<void> _openWhatsApp() async {
    if (_daerahUser == null) return;

    String phone = _daerahUser!.noTelp.trim();
    const message =
        'Halo saya mau bertanya terkait pengaduan';

    if (phone.isEmpty) return;

    if (phone.startsWith('08')) {
      phone = '62${phone.substring(1)}';
    }

    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // ===================== FETCH BERITA =====================
  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final api = ApiService();
      final allNews = await api.fetchBeritaByDaerah(token);

      beritaBantuan =
          allNews.where((b) => b.kategori.toLowerCase() == 'bantuan').toList();

      beritaUmum =
          allNews.where((b) => b.kategori.toLowerCase() == 'umum').toList();
    } catch (e) {
      debugPrint('Error load berita: $e');
    }

    if (mounted) setState(() => loading = false);
  }

  // ===================== FETCH DAERAH USER =====================
  Future<void> _loadDaerahUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final api = ApiService();
    _daerahUser = await api.fetchDaerahUser(token);

    if (mounted) setState(() {});
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TimelinePageContent(
        userName: widget.userData['nama'],
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
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          daerahUser: _daerahUser,
          openWhatsApp: _openWhatsApp,
        ),
      ),
    );
  }
}

// ===================== CONTENT =====================
class TimelinePageContent extends StatelessWidget {
  final String userName;
  final ScrollController scrollController;
  final bool loading;
  final List<Berita> sliderItems;
  final List<Berita> beritaList;
  final Future<void> Function() onRefresh;

  const TimelinePageContent({
    super.key,
    required this.userName,
    required this.scrollController,
    required this.loading,
    required this.sliderItems,
    required this.beritaList,
    required this.onRefresh,
  });

  void _goDetail(BuildContext context, Berita berita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailBeritaPage(berita: berita),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: HeaderBar(userName: userName)),

            // ===== Bantuan =====
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Berita Bantuan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: sliderItems.map((b) {
                        return GestureDetector(
                          onTap: () => _goDetail(context, b),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (b.foto != null && b.foto!.isNotEmpty)
                                  Image.network(
                                    b.foto!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black54,
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
                          ),
                        );
                      }).toList(),
                    ),
            ),

            // ===== Umum =====
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Berita Terbaru',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SliverList.builder(
              itemCount: beritaList.length,
              itemBuilder: (context, index) {
                final b = beritaList[index];
                return InkWell(
                  onTap: () => _goDetail(context, b),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (b.foto != null && b.foto!.isNotEmpty)
                          Image.network(
                            b.foto!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            b.judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

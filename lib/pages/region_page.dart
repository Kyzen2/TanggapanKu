import 'package:flutter/material.dart';
import 'package:tanggapanku/api/api_service.dart';
import 'package:tanggapanku/models/region.dart';

class RegionListPage extends StatefulWidget {
  const RegionListPage({super.key});

  @override
  State<RegionListPage> createState() => _RegionListPageState();
}

class _RegionListPageState extends State<RegionListPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  RegionPage? _regionPageData;
  bool _isLoading = true;
  String? _error;
  String _keyword = "";

  @override
  void initState() {
    super.initState();
    _fetchDaerah();
  }

  Future<void> _fetchDaerah() async {
    try {
      final data = await _apiService.fetchDaerah();
      setState(() {
        _regionPageData = data;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _regionPageData = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _regionPageData?.daerah ?? [];

    final filteredList = list
        .where((d) =>
            d.namaDaerah.toLowerCase().contains(_keyword.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Pilih Daerah',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2E2A6A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _errorState()
              : Column(
                  children: [
                    _searchBox(),
                    Expanded(
                      child: filteredList.isEmpty
                          ? _emptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final d = filteredList[index];
                                return _regionCard(d);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _searchBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _keyword = value);
        },
        decoration: InputDecoration(
          hintText: 'Cari daerah...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _regionCard(Daerah d) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.pop(
          context,
          {
            'id': d.id,
            'nama_daerah': d.namaDaerah,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF2E2A6A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF2E2A6A),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                d.namaDaerah,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        'Daerah tidak ditemukan',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Text(
        'Terjadi kesalahan\n$_error',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

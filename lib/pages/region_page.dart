// region_page.dart
import 'package:flutter/material.dart';
import 'package:tanggapanku/api/api_service.dart';

class RegionListPage extends StatefulWidget {
  const RegionListPage({super.key});

  @override
  State<RegionListPage> createState() => _RegionListPageState();
}

class _RegionListPageState extends State<RegionListPage> {
  final ApiService _apiService = ApiService();
  RegionPage? _regionPageData;
  bool _isLoading = true;
  String? _error;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kelurahan'),
        backgroundColor: Colors.blue, // Sesuaikan warna
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : list.isEmpty
                  ? const Center(child: Text('Data daerah kosong'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari Kelurahan...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            onChanged: (query) {
                              // Implement search functionality here if needed
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final d = list[index];
                                return Card(
                                  elevation: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: const Icon(Icons.location_city,
                                        size: 40),
                                    title: Text(
                                        d.namaDaerah ?? 'Tidak diketahui',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      // Return the selected region ID back to RegisterPage
                                      Navigator.pop(context, d.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

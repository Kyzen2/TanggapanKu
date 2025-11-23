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
        title: const Text('Daftar Daerah'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : list.isEmpty
                  ? const Center(child: Text('Data daerah kosong'))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final d = list[index];
                        return ListTile(
                          title: Text(d.namaDaerah),
                          subtitle: Text('ID: ${d.id}'),
                          onTap: () {
                            Navigator.pop(
                              context,
                              {
                                'id': d.id,
                                'nama_daerah': d.namaDaerah,
                              },
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

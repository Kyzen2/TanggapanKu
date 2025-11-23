import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanggapanku/models/region.dart';
import 'package:tanggapanku/models/register.dart';

class ApiService {
  static const String baseUrl =
      'https://firmly-splendid-dove.ngrok-free.app/api';

  /// GET /daerah
  Future<RegionPage> fetchDaerah() async {
    final uri = Uri.parse('$baseUrl/daerah');

    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(
        'Request gagal (${res.statusCode}). Body: ${_preview(res.body)}',
      );
    }

    final ct = res.headers['content-type'] ?? '';
    if (!ct.contains('application/json')) {
      throw Exception(
        'Server mengembalikan non-JSON ($ct). Body: ${_preview(res.body)}',
      );
    }

    final jsonMap = jsonDecode(res.body);
    return RegionPage.fromJson(jsonMap);
  }

  /// POST /register
  Future<Register> registerUser(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/register');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Gagal register (${res.statusCode}): ${_preview(res.body)}',
      );
    }

    final jsonMap = jsonDecode(res.body);
    return Register.fromJson(jsonMap);
  }

  String _preview(String s, [int max = 160]) {
    if (s.isEmpty) return '(kosong)';
    final clean = s.replaceAll('\n', ' ').replaceAll('\r', ' ');
    return clean.length <= max ? clean : '${clean.substring(0, max)}...';
  }
}

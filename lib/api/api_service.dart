import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanggapanku/models/region.dart';
import 'package:tanggapanku/models/register.dart';

class ApiService {
  static const String baseUrl =
      'https://firmly-splendid-dove.ngrok-free.app/api';

  // GET /daerah
  Future<RegionPage> fetchDaerah() async {
    final res = await http.get(
      Uri.parse('$baseUrl/daerah'),
      headers: {
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Request gagal: ${_preview(res.body)}');
    }

    final jsonMap = jsonDecode(res.body);
    return RegionPage.fromJson(jsonMap);
  }

  // POST /register
  Future<Register> registerUser(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(data),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Gagal register: ${_preview(res.body)}');
    }

    final jsonMap = jsonDecode(res.body);
    return Register.fromJson(jsonMap);
  }

  // POST /login
  Future<Map<String, dynamic>> loginUser(String nik, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "nik": nik,
        "password": password,
      }),
    );

    return {
      "status": res.statusCode,
      "body": jsonDecode(res.body),
    };
  }

  // Utility buat debug
  String _preview(String s, [int max = 160]) {
    final clean = s.replaceAll('\n', ' ').replaceAll('\r', ' ');
    return clean.length <= max ? clean : '${clean.substring(0, max)}...';
  }

  Future<Map<String, dynamic>> logoutUser(String token) async {
    final res = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        "Authorization": "Bearer $token",
        "accept": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    return {
      "status": res.statusCode,
      "body": jsonDecode(res.body),
    };
  }
}

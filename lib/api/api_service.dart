import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanggapanku/models/pengaduan.dart';
import 'package:tanggapanku/models/region.dart';
import 'package:tanggapanku/models/register.dart';
import 'package:tanggapanku/models/berita.dart';
import 'package:tanggapanku/models/berita_response.dart';

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

  // POST /logout
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

  // POST /pengaduan (multipart)
  Future<Map<String, dynamic>> postPengaduan({
    required String token,
    required String judul,
    required String deskripsi,
    List<String>? fotoPaths,
  }) async {
    final uri = Uri.parse('$baseUrl/pengaduan');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "accept": "application/json",
      'ngrok-skip-browser-warning': 'true',
    });

    request.fields['judul'] = judul;
    request.fields['deskripsi'] = deskripsi;

    // Upload banyak foto
    if (fotoPaths != null && fotoPaths.isNotEmpty) {
      for (var path in fotoPaths) {
        request.files.add(await http.MultipartFile.fromPath('foto[]', path));
      }
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    return {
      "status": response.statusCode,
      "body": jsonDecode(resBody),
    };
  }

  Future<BeritaResponse> fetchBerita(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/berita'),
      headers: {
        "Authorization": "Bearer $token",
        "accept": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Gagal load berita: ${_preview(res.body)}');
    }
    final jsonMap = jsonDecode(res.body);
    return BeritaResponse.fromJson(jsonMap);
  }

  Future<List<Pengaduan>> fetchRiwayatPengaduan(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/riwayat-pengaduan'),
      headers: {
        "Authorization": "Bearer $token",
        "accept": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Gagal load riwayat pengaduan: ${_preview(res.body)}');
    }

    final jsonMap = jsonDecode(res.body);
    final List<dynamic> pengaduanList = jsonMap['pengaduan'] ?? [];
    return pengaduanList.map((e) => Pengaduan.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> updateProfile({
    required String token,
    String? nama,
    String? noHp,
    String? alamat,
    String? password,
    String? fotoPath, // path file foto
  }) async {
    final uri = Uri.parse('$baseUrl/updateProfile');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "accept": "application/json",
      'ngrok-skip-browser-warning': 'true',
    });

    // field biasa
    if (nama != null) request.fields['nama'] = nama;
    if (noHp != null) request.fields['no_hp'] = noHp;
    if (alamat != null) request.fields['alamat'] = alamat;
    if (password != null) request.fields['password'] = password;

    // file foto
    if (fotoPath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('foto', fotoPath),
      );
    }

    // kirim
    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    return {
      "status": response.statusCode,
      "body": jsonDecode(resBody),
    };
  }
}

// tanggapanku/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // pastikan ini URL yang aktif
  static const String _baseUrl =
      'https://firmly-splendid-dove.ngrok-free.app/api/daerah';

  Future<RegionPage> fetchDaerah() async {
    // trik ngrok: tambahkan query agar gak dapat halaman warning HTML
    final uri = Uri.parse('$_baseUrl?ngrok-skip-browser-warning=true');
    final res = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
        // trik ngrok juga bisa via header:
        'ngrok-skip-browser-warning': 'true',
      },
    );

    // Log minimal saat dev
    // print('GET $uri -> ${res.statusCode}');
    // print('CT: ${res.headers['content-type']}');
    // print('BODY: ${res.body.substring(0, res.body.length > 500 ? 500 : res.body.length)}');

    // cek status code dulu
    if (res.statusCode < 200 || res.statusCode >= 300) {
      // kalau backend balikin HTML, kasih hint
      final ct = res.headers['content-type'] ?? '';
      if (!ct.contains('application/json')) {
        throw Exception(
          'HTTP ${res.statusCode} (non-JSON: $ct). Body awal: ${_preview(res.body)}',
        );
      }
      throw Exception('HTTP ${res.statusCode}: ${res.reasonPhrase}');
    }

    // pastikan content-type JSON sebelum decode
    final ct = res.headers['content-type'] ?? '';
    if (!ct.contains('application/json')) {
      throw Exception(
        'Server balikin non-JSON ($ct). Body awal: ${_preview(res.body)}',
      );
    }

    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    return RegionPage.fromJson(jsonMap);
  }

  String _preview(String s, [int max = 180]) {
    if (s.isEmpty) return '(empty)';
    final clean = s.replaceAll('\n', ' ').replaceAll('\r', ' ');
    return clean.length <= max ? clean : '${clean.substring(0, max)}...';
  }
}

// Class ApiService baru dengan request registerUser menggunakan POST, dan parameter tambahan 'region'
class ApiServiceRegister {
  final String _baseUrl =
      "https://firmly-splendid-dove.ngrok-free.app/api"; // Ganti dengan URL API yang sesuai

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'), // Endpoint untuk register
        headers: {
          'accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(data), // Data dikirim dalam format JSON
      );

      if (response.statusCode == 200) {
        // Jika response berhasil
        return jsonDecode(response.body);
      } else {
        // Jika response gagal
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Failed to connect to API');
    }
  }
}

// Model classes sama seperti yang sudah kamu definisikan:
class RegionPage {
  String? message;
  List<Daerah>? daerah;

  RegionPage({this.message, this.daerah});

  RegionPage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['daerah'] != null) {
      daerah = <Daerah>[];
      json['daerah'].forEach((v) {
        daerah!.add(Daerah.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (daerah != null) {
      data['daerah'] = daerah!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Daerah {
  int? id;
  String? namaDaerah;
  String? createdAt;
  String? updatedAt;

  Daerah({this.id, this.namaDaerah, this.createdAt, this.updatedAt});

  Daerah.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaDaerah = json['nama_daerah'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_daerah'] = namaDaerah;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

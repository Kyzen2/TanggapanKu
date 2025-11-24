import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanggapanku/models/post.dart';

class TimelineService {
  Future<List<Post>> getBerita(String token) async {
    final url = Uri.parse("https://firmly-splendid-dove.ngrok-free.app/api/berita");

    print("===== DEBUG TOKEN =====");
    print("Token JWT yang dikirim: $token");

    try {
      final res = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("===== DEBUG RESPONSE =====");
      print("Status code: ${res.statusCode}");
      print("Response body:\n${res.body}");

      if (res.statusCode == 200) {
        // Coba decode JSON
        try {
          final body = jsonDecode(res.body);
          if (body['berita'] == null) {
            throw Exception("Key 'berita' tidak ditemukan di response");
          }
          List data = body['berita'];
          return data.map((item) => Post.fromJson(item)).toList();
        } catch (e) {
          print("JSON decode error: $e");
          print("Body yang diterima:\n${res.body}");
          throw Exception("Response bukan JSON valid");
        }
      } else {
        throw Exception("Gagal mengambil berita, status code: ${res.statusCode}");
      }
    } catch (e) {
      print("Error saat fetch berita: $e");
      rethrow;
    }
  }
}

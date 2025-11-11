import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://firmly-splendid-dove.ngrok-free.app/api';

  Future<Map<String, dynamic>> registerUser({
    required String nama,
    required String noHp,
    required String nik,
    required String password,
    required String alamat,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        "nama": nama,
        "no_hp": noHp,
        "nik": nik,
        "password": password,
        "alamat": alamat,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Registration failed: ${response.statusCode} ${response.body}');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url =
        Uri.parse('https://firmly-splendid-dove.ngrok-free.app/api/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return {"status": response.statusCode, "body": jsonDecode(response.body)};
  }
}
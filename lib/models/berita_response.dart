import 'berita.dart';

class BeritaResponse {
  final String message;
  final int idDaerahWarga;
  final List<Berita> berita;

  BeritaResponse({
    required this.message,
    required this.idDaerahWarga,
    required this.berita,
  });

  factory BeritaResponse.fromJson(Map<String, dynamic> json) {
    return BeritaResponse(
      message: json['message'] ?? '',
      idDaerahWarga: json['id_daerah_warga'] ?? 0,
      berita: Berita.fromJsonList(json['berita'] ?? []),
    );
  }
}

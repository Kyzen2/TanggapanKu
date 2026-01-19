// models/region_models.dart

class RegionPage {
  final String? message;
  final List<Daerah> daerah;

  RegionPage({
    this.message,
    required this.daerah,
  });

  factory RegionPage.fromJson(Map<String, dynamic> json) {
    final list = (json['daerah'] as List? ?? [])
        .map((e) => Daerah.fromJson(e as Map<String, dynamic>))
        .toList();

    return RegionPage(
      message: json['message'] as String?,
      daerah: list,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'daerah': daerah.map((e) => e.toJson()).toList(),
    };
  }
}

class Daerah {
  final int id;
  final String namaDaerah;
  final String noTelp; // ditambah sesuai DB
  final String createdAt;
  final String updatedAt;

  Daerah({
    required this.id,
    required this.namaDaerah,
    required this.noTelp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Daerah.fromJson(Map<String, dynamic> json) {
    return Daerah(
      id: json['id'] ?? 0,
      namaDaerah: json['nama_daerah'] ?? '',
      noTelp: json['no_telp'] ?? '', // ambil dari API
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_daerah': namaDaerah,
      'no_telp': noTelp,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

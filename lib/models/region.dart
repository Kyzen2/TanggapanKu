// ===== models/region_models.dart =====

class RegionPage {
  final String? message;
  final List<Daerah> daerah;

  RegionPage({this.message, required this.daerah});

  factory RegionPage.fromJson(Map<String, dynamic> json) {
    // Banyak API ngirim variasi:
    // { "daerah": [...] } atau { "data": [...] } atau { "data": { "daerah": [...] } }
    dynamic rawList;
    if (json['daerah'] is List) {
      rawList = json['daerah'];
    } else if (json['data'] is List) {
      rawList = json['data'];
    } else if (json['data'] is Map && (json['data']['daerah'] is List)) {
      rawList = json['data']['daerah'];
    }

    final list = (rawList as List?)
            ?.map((e) => Daerah.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <Daerah>[];

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
  final int? id;
  final String? namaDaerah;
  final String? createdAt;
  final String? updatedAt;

  Daerah({
    this.id,
    this.namaDaerah,
    this.createdAt,
    this.updatedAt,
  });

  factory Daerah.fromJson(Map<String, dynamic> json) {
    return Daerah(
      id: json['id'] is String
          ? int.tryParse(json['id'] as String)
          : json['id'] as int?,
      // fallback key biar nggak kejebak kalau backend beda gaya penamaan
      namaDaerah: (json['nama_daerah'] ??
          json['namaDaerah'] ??
          json['nama'] ??
          json['region_name']) as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_daerah': namaDaerah,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

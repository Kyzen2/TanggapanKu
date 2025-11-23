class Register {
  final String message;
  final Warga warga;

  Register({
    required this.message,
    required this.warga,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      message: json['message'] ?? '',
      warga: Warga.fromJson(json['warga'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'warga': warga.toJson(),
    };
  }
}

class Warga {
  final int id;
  final int idDaerah;
  final String nama;
  final String nik;
  final String noHp;
  final String alamat;
  final String foto;
  final String status;
  final String createdAt;
  final String updatedAt;

  Warga({
    required this.id,
    required this.idDaerah,
    required this.nama,
    required this.nik,
    required this.noHp,
    required this.alamat,
    required this.foto,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Warga.fromJson(Map<String, dynamic> json) {
    return Warga(
      id: json['id'] ?? 0,
      idDaerah: json['id_daerah'] ?? 0,
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
      noHp: json['no_hp'] ?? '',
      alamat: json['alamat'] ?? '',
      foto: json['foto'] ?? '',
      status: json['status'] ?? 'offline',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_daerah': idDaerah,
      'nama': nama,
      'nik': nik,
      'no_hp': noHp,
      'alamat': alamat,
      'foto': foto,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

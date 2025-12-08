class Warga {
  final int id;
  final int idDaerah;
  final String? nama;
  final String nik;
  final String? noHp;
  final String? foto;
  final String? alamat;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Warga({
    required this.id,
    required this.idDaerah,
    this.nama,
    required this.nik,
    this.noHp,
    this.foto,
    this.alamat,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Warga.fromJson(Map<String, dynamic> json) {
    return Warga(
      id: json['id'] ?? 0,
      idDaerah: json['id_daerah'] ?? 0,
      nama: json['nama'],
      nik: json['nik'] ?? '',
      noHp: json['no_hp'],
      foto: json['foto'],
      alamat: json['alamat'],
      status: json['status'] ?? 'offline',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Tambahin ini
  factory Warga.fromMap(Map<String, dynamic> map) => Warga.fromJson(map);
}

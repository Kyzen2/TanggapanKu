class Berita {
  final int id;
  final int idDaerah;
  final int idOperator;
  final String judul;
  final String? deskripsi;
  final String? foto;
  final String tglTerbit;
  final String kategori;
  final String createdAt;
  final String updatedAt;

  Berita({
    required this.id,
    required this.idDaerah,
    required this.idOperator,
    required this.judul,
    required this.deskripsi,
    required this.foto,
    required this.tglTerbit,
    required this.kategori,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      id: json['id'],
      idDaerah: json['id_daerah'],
      idOperator: json['id_operator'],
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      tglTerbit: json['tgl_terbit'] ?? '',
      kategori: json['kategori'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static List<Berita> fromJsonList(List<dynamic> list) {
    return list.map((e) => Berita.fromJson(e)).toList();
  }
}

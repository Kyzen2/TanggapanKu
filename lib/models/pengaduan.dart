class Pengaduan {
  final int id;
  final int idWarga;
  final int idDaerah;
  final String judul;
  final String deskripsi;
  final String tglPengaduan;
  final String status;
  final List<PengaduanFoto> foto;

  Pengaduan({
    required this.id,
    required this.idWarga,
    required this.idDaerah,
    required this.judul,
    required this.deskripsi,
    required this.tglPengaduan,
    required this.status,
    required this.foto,
  });

  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      id: json['id'] ?? 0,
      idWarga: json['id_warga'] ?? 0,
      idDaerah: json['id_daerah'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      tglPengaduan: json['tgl_pengaduan'] ?? '',
      status: json['status'] ?? 'Diajukan',
      foto: (json['foto'] as List<dynamic>? ?? [])
          .map((e) => PengaduanFoto.fromJson(e))
          .toList(),
    );
  }
}

class PengaduanFoto {
  final int id;
  final int idPengaduan;
  final String pathFoto;

  PengaduanFoto({
    required this.id,
    required this.idPengaduan,
    required this.pathFoto,
  });

  factory PengaduanFoto.fromJson(Map<String, dynamic> json) {
    return PengaduanFoto(
      id: json['id'] ?? 0,
      idPengaduan: json['id_pengaduan'] ?? 0,
      pathFoto: json['path_foto'] ?? '',
    );
  }
}

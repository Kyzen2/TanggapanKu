class Register {
  String? message;
  Warga? warga;

  // Constructor untuk inisialisasi langsung
  Register({this.message, this.warga});

  // Constructor untuk inisialisasi dari JSON (biasanya untuk respons dari API)
  Register.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    warga = json['warga'] != null ? Warga.fromJson(json['warga']) : null;
  }

  // Mengubah data menjadi JSON untuk dikirim dengan POST
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (warga != null) {
      data['warga'] = warga!.toJson();
    }
    return data;
  }
}

class Warga {
  int? id;
  String? nama;
  String? noHp; // Pastikan noHp bertipe String
  String? nik; // Pastikan nik bertipe String
  String? password;
  String? alamat;
  int? idDaerah;

  // Constructor untuk inisialisasi langsung
  Warga({
    this.id,
    this.nama,
    this.noHp,
    this.nik,
    this.password,
    this.alamat,
    this.idDaerah,
  });

  // Constructor untuk inisialisasi dari JSON (biasanya untuk respons dari API)
  Warga.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    noHp = json['no_hp']; // Pastikan noHp bertipe String
    nik = json['nik']; // Pastikan nik bertipe String
    password = json['password'];
    alamat = json['alamat'];
    idDaerah = json['id_daerah'];
  }

  // Mengubah data menjadi JSON untuk dikirim dengan POST
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['nama'] = nama;
    data['no_hp'] = noHp; // Kirimkan noHp sebagai String
    data['nik'] = nik; // Kirimkan nik sebagai String
    data['password'] = password;
    data['alamat'] = alamat;
    data['id_daerah'] = idDaerah;
    return data;
  }
}

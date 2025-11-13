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
  String? nama;
  String? noHp;
  String? nik;
  String? password;
  String? alamat;
  String? updatedAt;
  String? createdAt;
  int? id;

  // Constructor untuk inisialisasi langsung
  Warga({
    this.nama,
    this.noHp,
    this.nik,
    this.password,
    this.alamat,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  // Constructor untuk inisialisasi dari JSON (biasanya untuk respons dari API)
  Warga.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    noHp = json['no_hp'];
    nik = json['nik'];
    password = json['password'];
    alamat = json['alamat'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  // Mengubah data menjadi JSON untuk dikirim dengan POST
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['nama'] = nama;
    data['no_hp'] = noHp;
    data['nik'] = nik;
    data['password'] = password;
    data['alamat'] = alamat;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

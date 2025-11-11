class register {
  String? _message;
  Warga? _warga;

  register({String? message, Warga? warga}) {
    if (message != null) {
      this._message = message;
    }
    if (warga != null) {
      this._warga = warga;
    }
  }

  String? get message => _message;
  set message(String? message) => _message = message; 
  Warga? get warga => _warga;
  set warga(Warga? warga) => _warga = warga;

  register.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _warga = json['warga'] != null ? new Warga.fromJson(json['warga']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    if (this._warga != null) {
      data['warga'] = this._warga!.toJson();
    }
    return data;
  }
}

class Warga {
  String? _nama;
  String? _noHp;
  String? _nik;
  String? _password;
  String? _alamat;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  Warga(
      {String? nama,
      String? noHp,
      String? nik,
      String? password,
      String? alamat,
      String? updatedAt,
      String? createdAt,
      int? id}) {
    if (nama != null) {
      this._nama = nama;
    }
    if (noHp != null) {
      this._noHp = noHp;
    }
    if (nik != null) {
      this._nik = nik;
    }
    if (password != null) {
      this._password = password;
    }
    if (alamat != null) {
      this._alamat = alamat;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (id != null) {
      this._id = id;
    }
  }

  String? get nama => _nama;
  set nama(String? nama) => _nama = nama;
  String? get noHp => _noHp;
  set noHp(String? noHp) => _noHp = noHp;
  String? get nik => _nik;
  set nik(String? nik) => _nik = nik;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get alamat => _alamat;
  set alamat(String? alamat) => _alamat = alamat;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  int? get id => _id;
  set id(int? id) => _id = id;

  Warga.fromJson(Map<String, dynamic> json) {
    _nama = json['nama'];
    _noHp = json['no_hp'];
    _nik = json['nik'];
    _password = json['password'];
    _alamat = json['alamat'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this._nama;
    data['no_hp'] = this._noHp;
    data['nik'] = this._nik;
    data['password'] = this._password;
    data['alamat'] = this._alamat;
    data['updated_at'] = this._updatedAt;
    data['created_at'] = this._createdAt;
    data['id'] = this._id;
    return data;
  }
}
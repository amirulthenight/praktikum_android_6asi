class Mahasiswa {
  final int? id;
  final String nama;
  final String npm;
  final String tempatLahir;
  final String tanggalLahir;
  final String sex;
  final String alamat;
  final String telp;
  final String email;
  final String? photo;

  Mahasiswa({
    this.id,
    required this.npm,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.sex,
    required this.alamat,
    required this.telp,
    required this.email,
    this.photo,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    return Mahasiswa(
      id: json['id'],
      npm: json['npm'] ?? '', // jika null, isi dengan empty string
      nama: json['nama'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      sex: json['sex'] ?? '',
      alamat: json['alamat'] ?? '',
      telp: json['telp'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'], // photo nullable, biarkan seperti ini
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'npm': npm,
      'nama': nama,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'sex': sex,
      'alamat': alamat,
      "telp": telp,
      "email": email,
      "photo": photo,
    };
  }
}

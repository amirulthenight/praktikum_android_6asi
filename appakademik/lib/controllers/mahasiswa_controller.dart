import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mahasiswa.dart';

class MahasiswaController extends GetxController {
  var mahasiswaList = <Mahasiswa>[].obs;

  //final String apiUrl = 'http://10.0.2.2:8000/api/mahasiswa/';
  final String apiUrl = 'http://127.0.0.1:8000/api/mahasiswa';
  // final String apiUrl = 'http://192.168.237.250:8000/api/mahasiswa';
  // final String apiUrl = 'http:/http://127.0.0.1:8000/api/mahasiswa';


  @override
  void onInit() {
    super.onInit();
    addDataMahasiswa();
  }

  Future<void> addDataMahasiswa() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      mahasiswaList.value =
          data.map((item) => Mahasiswa.fromJson(item)).toList();
    } else {
      throw Exception('Gagal Ambil Data Mahasiswa');
    }
  }

  Future<void> tambahMahasiswa(Mahasiswa mahasiswa) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(mahasiswa.toJson()),
    );

    if (response.statusCode == 201) {
      mahasiswaList.add(Mahasiswa.fromJson(json.decode(response.body)));
    } else {
      throw Exception('Gagal Simpan Data Mahasiswa');
    }
  }

  Future<void> ubahMahasiswa(int id, Mahasiswa mahasiswa) async {
    final response = await http.put(
      Uri.parse('$apiUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mahasiswa.toJson()),
    );

    if (response.statusCode == 200) {
      final index = mahasiswaList.indexWhere((m) => m.id == id);
      if (index != -1) {
        mahasiswaList[index] = Mahasiswa.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Gagal Ubah Data Mahasiswa');
    }
  }

  Future<void> hapusMahasiswa(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl$id/'));

    if (response.statusCode == 204) {
      mahasiswaList.removeWhere((m) => m.id == id);
    } else {
      throw Exception('Gagal Hapus Data Mahasiswa');
    }
  }
}

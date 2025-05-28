import 'package:appakademik/models/mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mahasiswa_controller.dart';
import 'ubah_mahasiswa.dart';
//import '../models/mahasiswa.dart';
import 'tambah_mahasiswa.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MahasiswaView extends StatelessWidget {
  MahasiswaView({super.key});
  final MahasiswaController controller = Get.put(MahasiswaController());

  Future<void> generatePdf(List<Mahasiswa> mahasiswas) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Laporan Mahasiswa', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['NPM', 'Nama', 'Email', 'Jenis Kelamin'],
                data:
                    mahasiswas.map((mahasiswa) {
                      return [
                        mahasiswa.npm,
                        mahasiswa.nama,
                        mahasiswa.email,
                        mahasiswa.sex == 'L' ? 'Laki-Laki' : 'Perempuan',
                      ];
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data Mahasiswa")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.mahasiswaList.isEmpty) {
                return Center(child: Text("Tidak ada data mahasiswa"));
              }
              return ListView.builder(
                itemCount: controller.mahasiswaList.length,
                itemBuilder: (context, index) {
                  final mahasiswa = controller.mahasiswaList[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              mahasiswa.photo ??
                                  'https://w7.pngwing.com/pngs/358/81/png-transparent-computer-icons-graduationceremony-college-student-financial-aid-graduated-people-logo-graduationceremony.png',
                            ), // Ganti dengan URL foto
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mahasiswa.nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text("NPM: ${mahasiswa.npm}"),
                                Text("Email: ${mahasiswa.email}"),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              controller.hapusMahasiswa(mahasiswa.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(
                () => TambahMahasiswaView(),
              ); // Ini untuk navigasi ke halaman Tambah Mahasiswa
            },
            child: Text("Tambah Mahasiswa"),
          ),
        ],
      ),
    );
  }
}

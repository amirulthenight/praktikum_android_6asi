import 'package:appakademik/models/mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mahasiswa_controller.dart';
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
            pw.Text('Laporan Mahasiswa', 
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['npm', 'nama', 'email', 'jenis_kelamin', 'tempat_lahir', 'tanggal_lahir'],
              data: mahasiswas.map((mahasiswa) {
                return [
                  mahasiswa.npm,
                  mahasiswa.nama,
                  mahasiswa.email,
                  mahasiswa.sex == 'L' ? 'Laki-Laki' : 'Perempuan',
                  mahasiswa.tempatLahir,
                  mahasiswa.tanggalLahir,
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.blue800,
              ),
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.center,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.center,
              },
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mahasiswa
                                .nama, // Pastikan pakai name sesuai dengan model
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("NPM: ${mahasiswa.npm}"),
                          Text("Email: ${mahasiswa.email}"),
                          Text("Tempat Lahir: ${mahasiswa.tempatLahir}"),
                          Text("Tanggal Lahir: ${mahasiswa.tanggalLahir}"),
                          Text(
                            "Jenis Kelamin: ${mahasiswa.sex == 'L' ? 'Laki-Laki' : 'Perempuan'}", // Perbaikan pada jenis kelamin
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .end, // Gunakan Row untuk tombol
                            children: <Widget>[
                              TextButton(
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  if (mahasiswa.id != null) {
                                    controller.hapusMahasiswa(mahasiswa.id!);
                                  }
                                },
                              ),
                              // Tambahkan tombol Edit jika perlu
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

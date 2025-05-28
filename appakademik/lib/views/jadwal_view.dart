import 'package:flutter/material.dart';
import 'package:appakademik/models/jadwal.dart';
import 'package:appakademik/controllers/jadwal_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class JadwalPage extends StatefulWidget {
  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late Future<List<Jadwal>> futureJadwal;
  final JadwalService _service = JadwalService();

  @override
  void initState() {
    super.initState();
    futureJadwal = _service.getJadwal();
  }

  Future<void> generatePdf(List<Jadwal> jadwals) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Laporan Jadwal', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Nama Mata Kuliah', 'Tanggal', 'Jam', 'Ruangan'],
                data: jadwals.map((jadwal) {
                  return [
                    jadwal.namaMatakuliah,
                    jadwal.tanggal,
                    jadwal.jam,
                    jadwal.ruangan,
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

  Future<void> _showForm(BuildContext context, {Jadwal? jadwal}) {
    final namaMatakuliahController = TextEditingController(text: jadwal?.namaMatakuliah);
    final tanggalController = TextEditingController(text: jadwal?.tanggal);
    final jamController = TextEditingController(text: jadwal?.jam);
    final ruanganController = TextEditingController(text: jadwal?.ruangan);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(jadwal == null ? 'Tambah Jadwal' : 'Ubah Jadwal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaMatakuliahController,
                decoration: InputDecoration(labelText: 'Nama Mata Kuliah'),
              ),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
              ),
              TextField(
                controller: jamController,
                decoration: InputDecoration(labelText: 'Jam'),
              ),
              TextField(
                controller: ruanganController,
                decoration: InputDecoration(labelText: 'Ruangan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newJadwal = Jadwal(
                  id: jadwal?.id,
                  namaMatakuliah: namaMatakuliahController.text,
                  tanggal: tanggalController.text,
                  jam: jamController.text,
                  ruangan: ruanganController.text,
                );

                if (jadwal == null) {
                  _service.createJadwal(newJadwal).then((_) {
                    Navigator.of(context).pop();
                    setState(() {
                      futureJadwal = _service.getJadwal();
                    });
                  });
                } else {
                  _service.updateJadwal(jadwal.id!, newJadwal).then((_) {
                    Navigator.of(context).pop();
                    setState(() {
                      futureJadwal = _service.getJadwal();
                    });
                  });
                }
              },
              child: Text(jadwal == null ? 'Tambah' : 'Ubah'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteJadwal(int id) async {
    await _service.deleteJadwal(id);
    setState(() {
      futureJadwal = _service.getJadwal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showForm(context),
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              futureJadwal.then((jadwals) {
                generatePdf(jadwals);
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Jadwal>>(
        future: futureJadwal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Data Jadwal Kosong'));
          }
          
          final jadwals = snapshot.data!;
          return ListView.builder(
            itemCount: jadwals.length,
            itemBuilder: (context, index) {
              final jadwal = jadwals[index];
              return ListTile(
                title: Text(jadwal.namaMatakuliah),
                subtitle: Text('${jadwal.tanggal} - ${jadwal.jam} (${jadwal.ruangan})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showForm(context, jadwal: jadwal),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteJadwal(jadwal.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
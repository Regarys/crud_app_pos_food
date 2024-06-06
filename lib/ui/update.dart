import 'package:flutter/material.dart';
import 'package:untitled/model.dart';
import 'package:untitled/service.dart';

class UpdateMakananPage extends StatefulWidget {
  final ModelMakanan makanan;

  UpdateMakananPage({required this.makanan});

  @override
  _UpdateMakananPageState createState() => _UpdateMakananPageState();
}

class _UpdateMakananPageState extends State<UpdateMakananPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.makanan.nama ?? '';
    hargaController.text = widget.makanan.harga ?? '';
    linkController.text = widget.makanan.link ?? '';
    deskripsiController.text = widget.makanan.deskripsi ?? '';
    categoryController.text = widget.makanan.category ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFC6736),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C2D57),
        title: Text('Update Makanan',style: TextStyle(color: Color(0xffFFB0B0)),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Makanan'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: hargaController,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Link Gambar'),
            ),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                updateDataMakanan();
              },
              child: Text('Update Makanan',style: TextStyle(fontSize: 16),),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff0C2D57))),
            ),
          ],
        ),
      ),
    );
  }

  void updateDataMakanan() async {
    try {
      int makananId = int.parse(widget.makanan.id ?? '0');
      await apiService.updateDataMakanan(
        id: makananId.toString(),
        nama: namaController.text,
        harga: hargaController.text,
        link: linkController.text,
        deskripsi: deskripsiController.text,
        category: categoryController.text,
      );

      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Makanan berhasil diupdate!'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi
      print('Error during API request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengupdate data. Silakan coba lagi.'),
        ),
      );
    }
  }


}

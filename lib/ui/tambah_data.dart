import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/service.dart';

class AddMakananPage extends StatefulWidget {
  @override
  _AddMakananPageState createState() => _AddMakananPageState();
}

class _AddMakananPageState extends State<AddMakananPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final apiService = ApiService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFC6736),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C2D57),
        title: Text('Tambah Makanan',style: TextStyle(color: Color(0xffFFB0B0))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Makanan'),
            ),
            TextFormField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextFormField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Link Gambar'),
            ),
            TextFormField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                tambahDataMakanan();
              },
              child: Text('Tambahkan Makanan',style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff0C2D57)))
            ),
          ],
        ),
      ),
    );
  }

  void tambahDataMakanan() async {
    try {
      await apiService.tambahDataMakanan(
        nama: namaController.text,
        harga: hargaController.text,
        link: linkController.text,
        deskripsi: deskripsiController.text,
        category: categoryController.text,
      );
      Navigator.pop(context, true);
      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Makanan berhasil ditambahkan!'),
        ),
      );
    } catch (e) {
      print('Error during API request: $e');

      if (e is DioError) {
        // Cetak informasi lengkap dari DioError
        print('DioError details: ${e.response?.data}, ${e.response
            ?.statusCode}, ${e.response?.statusMessage}');
      }

      if (e is DioException) {
        // Ini adalah kasus ketika kesalahan berasal dari Dio (seperti DioException [unknown])
        print('Error Dio: ${e.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan data. Silakan coba lagi.'),
          ),
        );
      } else {
        // Ini adalah kasus ketika kesalahan berasal dari respons yang tidak sesuai dengan format JSON
        print('Error lain: ${e.toString()}');

        // Tambahan: Menangani kesalahan format JSON
        if (e is FormatException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Gagal menambahkan data. Respons tidak sesuai dengan format JSON.'),
            ),
          );
        } else {
          if (e is DioError) {
            // Cetak informasi lengkap dari DioError
            print('DioError details: ${e.response?.data}, ${e.response
                ?.statusCode}, ${e.response?.statusMessage}');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gagal menambahkan data. Silakan coba lagi.'),
                )
            );
          }
        }
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:untitled/model.dart';
import 'package:untitled/service.dart';
import 'package:untitled/ui/transaksi.dart';
import 'package:untitled/ui/update.dart';

class DetailPage extends StatefulWidget {
  final ModelMakanan makanan;

  DetailPage({required this.makanan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFC6736),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C2D57),
        title: Text(
          'Detail Makanan',
          style: TextStyle(color: Color(0xffFFB0B0)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.makanan.link ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${widget.makanan.nama ?? ''}',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rp${widget.makanan.harga?.replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match match) => '${match[1]},',
                      ) ?? '0.00'}',
                      style: TextStyle(fontSize: 18),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateMakananPage(makanan: widget.makanan)));
                    },
                    child: Text(
                      'Update Data',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff0C2D57))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      hapusData();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red),
                    child:
                        Text('Hapus Data', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Container(
                  padding: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransaksiPage(makanan: widget.makanan)));
                    },
                    child: Icon(Icons.shopping_cart),
                    backgroundColor: Color(0xffFFA559),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void hapusData() async {
    try {
      await apiService.hapusDataMakanan(widget.makanan.id!);
      // Menampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Makanan berhasil dihapus!'),
        ),
      );
      // Navigasi kembali ke halaman sebelumnya atau sesuai kebutuhan
      Navigator.pop(context);
    } catch (e) {
      // Menampilkan pesan kesalahan jika terjadi
      debugPrint('Error hapus data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus data. Silakan coba lagi.'),
        ),
      );
    }
  }
}

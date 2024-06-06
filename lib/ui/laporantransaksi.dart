import 'package:flutter/material.dart';
import 'package:untitled/model.dart';

class LaporanPage extends StatelessWidget {
  final ModelMakanan makanan;
  final int quantity;
  final int hargaTotal;
  final int uangPembeli;
  final int kembalian;

  LaporanPage({
    required this.makanan,
    required this.quantity,
    required this.hargaTotal,
    required this.uangPembeli,
    required this.kembalian,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey,
                child: Center(
                  child: Text(
                    'Bon Transaksi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID Makanan: ${makanan.id ?? ''}'),
                    Text('Nama Makanan: ${makanan.nama ?? ''}'),
                    Text('Harga Makanan: Rp.${makanan.harga ?? ''}'),
                    SizedBox(height: 16),
                    Text('Jumlah yang Dibeli: $quantity'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total'),
                    Text('Rp.$hargaTotal'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Uang Pembeli'),
                    Text('Rp.$uangPembeli'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kembalian'),
                    Text('Rp.$kembalian'),
                  ],
                ),
              ),
              SizedBox(height: 160),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke menu utama
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text('Kembali ke Menu Utama',style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

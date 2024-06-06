import 'package:flutter/material.dart';
import 'package:untitled/model.dart';
import 'package:untitled/service.dart';
import 'package:untitled/ui/laporantransaksi.dart';

class TransaksiPage extends StatefulWidget {
  final ModelMakanan makanan; 
  TransaksiPage(
      {required this.makanan});

  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final apiService = ApiService();
  ModelMakanan? makananDetail;
  TextEditingController quantityController = TextEditingController();
  TextEditingController hargaTotalController = TextEditingController();
  TextEditingController uangPembeliController = TextEditingController();
  TextEditingController kembalianController = TextEditingController();

  void updateTotalPrice() {
    int quantity = int.tryParse(quantityController.text) ?? 0;
    int hargaTotal = calculateTotalPrice(quantity);
    hargaTotalController.text = hargaTotal.toString();
  }

  void updateKembalian() {
    int hargaTotal = int.tryParse(hargaTotalController.text) ?? 0;
    int uangPembeli = int.tryParse(uangPembeliController.text) ?? 0;
    int kembalian = uangPembeli - hargaTotal;

    // Ensure kembalian is non-negative
    kembalian = kembalian < 0 ? 0 : kembalian;

    kembalianController.text = kembalian.toString();
  }

  @override
  void initState() {
    super.initState();
    loadDetailMakanan();
  }

  int calculateTotalPrice(int quantity) {
    return quantity * int.parse(makananDetail?.harga ?? '0');
  }

  Future<void> loadDetailMakanan() async {
    try {
      // Mengambil detail makanan dari properti makanan di widget
      makananDetail = widget.makanan;
      setState(
          () {}); // Memperbarui tampilan setelah mendapatkan detail makanan
    } catch (error) {
      print('Error loading detail makanan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (makananDetail == null) {
      // Tampilkan loading atau indikator lainnya jika makananDetail belum diinisialisasi
      return CircularProgressIndicator();
    }
    return Scaffold(
      backgroundColor: Color(0xffFC6736),
      appBar: AppBar(
        backgroundColor: Color(0xFF0C2D57),
        title: Text('Proses Transaksi', style: TextStyle(color: Color(0xffFFB0B0)),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  widget.makanan.link ?? '',
                  height: 200,
                  width: 200, // Sesuaikan lebar dan tinggi agar gambar berbentuk persegi
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text('ID Makanan: ${widget.makanan.id ?? ''}'),
              Text('Nama Makanan: ${widget.makanan.nama ?? ''}'),
              Text('Harga: Rp.${widget.makanan.harga ?? ''}'),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  updateTotalPrice();
                },
              ),
              TextField(
                controller: hargaTotalController,
                decoration: InputDecoration(labelText: 'Harga Total'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: uangPembeliController,
                decoration: InputDecoration(labelText: 'Uang Pembeli'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  updateKembalian();
                },
              ),
              TextField(
                controller: kembalianController,
                decoration: InputDecoration(labelText: 'Kembalian'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  tambahTransaksi();
                },
                child: Text('Kirim Transaksi',style: TextStyle(color: Colors.white),),style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff0C2D57))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> tambahTransaksi() async {
    try {
      int quantity = int.tryParse(quantityController.text) ?? 0;
      int hargaTotal = int.tryParse(hargaTotalController.text) ?? 0;
      int uangPembeli = int.tryParse(kembalianController.text) ?? 0;
      int kembalian = int.tryParse(kembalianController.text) ?? 0;

      await apiService.tambahTransaksi(
        transaction: Transaction(
          quantity: quantity,
          totalPrice: hargaTotal,
          costmerMoney: uangPembeli,
          changeAmount: kembalian,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaporanPage(
            makanan: widget.makanan,
            quantity: quantity,
            hargaTotal: hargaTotal,
            uangPembeli: uangPembeli,
            kembalian: kembalian,
          ),
        ),
      );
      // Berhasil menambahkan transaksi, tambahkan logika atau tampilan sesuai kebutuhan
    } catch (error) {
      // Tangani kesalahan, tambahkan logika atau tampilan sesuai kebutuhan
      print('Error during API request: $error');
    }
  }
}

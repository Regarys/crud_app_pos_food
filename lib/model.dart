class ModelMakanan {
  String? id;
  String? nama;
  String? harga;
  String? link; // Ubah menjadi String
  String? deskripsi; // Ubah menjadi String
  String? category;

  ModelMakanan({
    this.id,
    this.nama,
    this.harga,
    this.link,
    this.deskripsi,
    this.category,
  });

  // Tambahkan konstruktor factory untuk membentuk objek ModelMakanan dari JSON
  factory ModelMakanan.fromJson(Map<String, dynamic> json) {
    return ModelMakanan(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'],
      link: json['link'],
      deskripsi: json['deskripsi'],
      category: json['category'],
    );
  }
}

class Transaction {
  final int quantity;
  final int totalPrice;
  final int costmerMoney;
  final int changeAmount;

  Transaction({
    required this.quantity,
    required this.totalPrice,
    required this.costmerMoney,
    required this.changeAmount,
  });
}


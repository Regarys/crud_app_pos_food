import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled/model.dart';
import 'package:untitled/response.dart';

final dio = Dio();

class ApiService {
  Future<ResponseMakanan> getapi() async {
    try {
      final response = await dio.get('http://192.168.1.6/makananmobile/data.php');
      print('API Response: $response');
      final data = ResponseMakanan.fromJson(response.data);
      print('Converted Data: $data');
      if (response.statusCode == 200) {
        // debugPrint('GET Product : ${response.data}');
        return ResponseMakanan.fromJson(response.data);
      } else {
        debugPrint('Failed to load data. Status code: ${response.statusCode}');
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during API request: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Response> tambahDataMakanan({
    required String nama,
    required String harga,
    required String link,
    required String deskripsi,
    required String category,
  }) async {
    try {
      final response = await dio.post(
        Uri.parse('http://192.168.1.6/makananmobile/create.php').toString(),
        data: {
          'nama': nama,
          'harga': harga,
          'link': link,
          'deskripsi': deskripsi,
          'category': category,
        },
      );

      return response;
    } catch (e) {
      print('Error during API request: ${e.toString()}.');
      throw Exception('Gagal menambahkan data: ${e.toString()}');
    }
  }

  Future<void> updateDataMakanan({
    required String id,
    required String nama,
    required String harga,
    required String link,
    required String deskripsi,
    required String category,
  }) async {
    try {
      final response = await dio.post(
        'http://192.168.1.6/makananmobile/update.php',
        data: {
          'id': id,
          'nama': nama,
          'harga': harga,
          'link': link,
          'deskripsi': deskripsi,
          'category': category,
        },
      );

      debugPrint('Respons dari server: ${response.data}');

      if (response.statusCode == 200) {
        debugPrint('Data berhasil diupdate: ${response.data}');

        // Cek apakah status success
        if (response.data['status'] == 'success') {
          return; // Data berhasil diupdate
        } else {
          throw Exception('Gagal mengupdate data: ${response.data['message']}');
        }
      } else {
        throw Exception('Gagal mengupdate data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during API request: $e');
      throw Exception('Gagal mengupdate data: $e');
    }
  }

  Future<void> hapusDataMakanan(String id) async {
    try {
      final response = await dio.post(
        Uri.parse('http://192.168.1.6/makananmobile/delete.php').toString(),
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        // Data berhasil dihapus
        debugPrint('Data berhasil dihapus: ${response.data}');
      } else {
        // Permintaan tidak berhasil
        debugPrint('Gagal menghapus data. Status code: ${response.statusCode}');
        throw Exception('Gagal menghapus data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during API request: $e');
      throw Exception('Gagal menghapus data: $e');
    }
  }




  Future<void> tambahTransaksi({required Transaction transaction}) async {
    try {
      final response = await dio.post(
        Uri.parse('http://192.168.1.6/makananmobile/transaksi.php').toString(),
        data: {
          'qty': transaction.quantity.toString(),
          'harga_total': transaction.totalPrice.toString(),
          'uangPembeli' :transaction.costmerMoney.toString(),
          'kembalian': transaction.changeAmount.toString(),
        },
      );

      // Cek apakah request sukses atau tidak
      if (response.statusCode == 200) {
        print('Transaksi berhasil ditambahkan.');
      } else {
        print('Gagal menambahkan transaksi. Status code: ${response.statusCode}');
        throw Exception('Gagal menambahkan transaksi. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API request: $e');
      throw Exception('Gagal menambahkan transaksi: $e');
    }
  }

  Future<List<ModelMakanan>> searchMakanan(String query) async {
    try {
      final response = await dio.post(
        'http://192.168.1.6/makananmobile/search.php',
        data: {'query': query},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data['data'] ?? [];
        return jsonList.map((item) => ModelMakanan.fromJson(item)).toList();
      } else {
        print('Gagal menghubungi server. Status Code: ${response.statusCode}');
        throw Exception('Gagal menghubungi server. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat permintaan API: $e');
      throw Exception('Gagal melakukan pencarian: $e');
    }
  }


}


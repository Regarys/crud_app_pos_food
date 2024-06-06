import 'package:untitled/model.dart';
import 'dart:convert';


class ResponseMakanan {
  List<ModelMakanan> listMakanan = [];

  ResponseMakanan.fromJson(String jsonString) {
    List<dynamic> jsonList = json.decode(jsonString);
    listMakanan = jsonList.map((item) => ModelMakanan.fromJson(item)).toList();
  }

  List<ModelMakanan> get makananList => listMakanan;
}


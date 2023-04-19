import 'dart:convert';
import 'package:admin_flutter/controller/auth.dart';
import 'package:admin_flutter/models/product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

getProduct(context) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products";

  Uri parseUrl = Uri.parse(url);
  final response =
      await http.get(parseUrl, headers: {"Cookie": token.toString()});

  if (response.statusCode == 200) {
    var res = jsonDecode(response.body);
    List<Product> list = [];

    for (var data in res as List) {
      list.add(Product.fromJson(jsonEncode(data)));
    }
    return list;
  }
  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return;
  }
}

createProduct(context, name, description, stock) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products";

  Map data = {
    'nama_produk': name,
    'deskripsi': description,
    'gambar': '',
    'stok': int.parse(stock),
  };
  var body = jsonEncode(data);

  Uri parseUrl = Uri.parse(url);
  final response = await http.post(parseUrl,
      headers: {"Cookie": token.toString()}, body: body);

  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return response;
  }
}

editProduct(context, name, description, stock, id) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products/$id";

  Map data = {
    'nama_produk': name,
    'deskripsi': description,
    'gambar': '',
    'stok': int.parse(stock),
  };
  var body = jsonEncode(data);

  Uri parseUrl = Uri.parse(url);
  final response = await http.patch(parseUrl,
      headers: {"Cookie": token.toString()}, body: body);

  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return response;
  }
}

deleteProduct(context, id) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products/$id";

  Uri parseUrl = Uri.parse(url);
  final response =
      await http.delete(parseUrl, headers: {"Cookie": token.toString()});

  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return response;
  }
}

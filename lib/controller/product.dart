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

createProduct(context, name, description, stock, imageName, imagePath) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products";

  Map<String, String> data = {
    'nama_produk': name,
    'deskripsi': description,
    'stok': stock,
  };

  Uri parseUrl = Uri.parse(url);

  var request = http.MultipartRequest('POST', parseUrl);
  request.headers['Cookie'] = token.toString();

  if (imagePath != '') {
    var file = await http.MultipartFile.fromPath("assets", imagePath,
        filename: imageName);
    request.files.add(file);
  }

  request.fields.addAll(data);

  final response = await request.send();
  final res = await response.stream.bytesToString();
  var resDecode = jsonDecode(res);

  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return resDecode['message'];
  }
}

updateProduct(
    context, name, description, stock, id, imageName, imagePath) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/products/$id";

  Map<String, String> data = {
    'nama_produk': name,
    'deskripsi': description,
    'stok': stock,
  };

  Uri parseUrl = Uri.parse(url);

  var request = http.MultipartRequest('PATCH', parseUrl);
  request.headers['Cookie'] = token.toString();

  if (imagePath != '') {
    var file = await http.MultipartFile.fromPath("assets", imagePath,
        filename: imageName);
    request.files.add(file);
  }

  request.fields.addAll(data);

  final response = await request.send();
  final res = await response.stream.bytesToString();
  var resDecode = jsonDecode(res);

  if (response.statusCode == 401) {
    unauthorized(context);
    return;
  } else {
    return resDecode['message'];
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

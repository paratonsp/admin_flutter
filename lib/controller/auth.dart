import 'dart:convert';

import 'package:admin_flutter/view/loginPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

login(String email, password) async {
  String url = "http://103.54.170.102:8080/login";

  Map data = {'username': email, 'password': password};
  var body = jsonEncode(data);

  Uri parseUrl = Uri.parse(url);
  final response = await http.post(parseUrl,
      headers: {"Content-Type": "application/json"}, body: body);

  return response;
}

logout() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/logout";

  Uri parseUrl = Uri.parse(url);
  final response =
      await http.get(parseUrl, headers: {"Cookie": token.toString()});

  return response;
}

check() async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");
  String url = "http://103.54.170.102:8080/api/check";

  Uri parseUrl = Uri.parse(url);
  final response =
      await http.get(parseUrl, headers: {"Cookie": token.toString()});

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

updateCookie(http.Response response) async {
  const storage = FlutterSecureStorage();
  String token;
  String? rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
    int index = rawCookie.indexOf(';');
    token = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    await storage.write(key: 'token', value: token);
  }
}

unauthorized(context) async {
  Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => const LoginPage(),
    ),
  );
}

// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:admin_flutter/controller/auth.dart';
import 'package:admin_flutter/layout/app_layout.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoad = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  loginButton() async {
    await login(email.text, password.text).then((val) async {
      String res = jsonDecode(val.body)['message'];
      if (val.statusCode == 200) {
        updateCookie(val);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
          duration: const Duration(seconds: 1),
        ));
        Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AppLayout(),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
          duration: const Duration(seconds: 1),
        ));
      }
    });
  }

  checkToken() async {
    await check().then((val) {
      if (val) {
        Timer(const Duration(milliseconds: 1500), () {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AppLayout(),
            ),
          );
        });
      } else {
        setState(() {
          isLoad = false;
        });
      }
    });
  }

  @override
  void initState() {
    checkToken();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
              minWidth: 250, maxWidth: 250, maxHeight: 200),
          decoration: BoxDecoration(
            borderRadius: Styles.defaultBorderRadius,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(Styles.defaultPadding),
          child: (isLoad)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Authenticating..."),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: email,
                      onSubmitted: (x) => loginButton(),
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Email",
                        icon: Icon(CupertinoIcons.mail),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      controller: password,
                      onSubmitted: (x) => loginButton(),
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Password",
                        icon: Icon(CupertinoIcons.padlock),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 250,
                      child: CupertinoButton.filled(
                        child: const Text("Sign In"),
                        onPressed: () => loginButton(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

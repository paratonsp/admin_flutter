// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:admin_flutter/controller/auth.dart';
import 'package:admin_flutter/responsive.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:admin_flutter/view/dashboardPage.dart';
import 'package:admin_flutter/view/loginPage.dart';
import 'package:admin_flutter/view/productPage.dart';
import 'package:admin_flutter/widgets/navigation_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

enum NavigationItems {
  home,
  product,
}

var section;

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    section = NavigationItems.home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget switchBody = const SizedBox();
    switch (section) {
      case NavigationItems.home:
        switchBody = const DashBoardPage();
        break;
      case NavigationItems.product:
        switchBody = const ProductPage();
        break;
      default:
        switchBody = const DashBoardPage();
        break;
    }
    return Scaffold(
      body: Responsive(
        mobile: Column(
          children: [
            topAppBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: switchBody,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NavigationButton(
                          onPressed: () {
                            setState(() {
                              section = NavigationItems.home;
                            });
                          },
                          icon: Icons.home,
                          isActive: NavigationItems.home == section,
                        ),
                        NavigationButton(
                          onPressed: () {
                            setState(() {
                              section = NavigationItems.product;
                            });
                          },
                          icon: Icons.inventory_2_outlined,
                          isActive: NavigationItems.product == section,
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset("assets/logo.png", height: 50),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NavigationButton(
                          onPressed: () {
                            setState(() {
                              section = NavigationItems.home;
                            });
                          },
                          icon: Icons.home,
                          isActive: NavigationItems.home == section,
                        ),
                        NavigationButton(
                          onPressed: () {
                            setState(() {
                              section = NavigationItems.product;
                            });
                          },
                          icon: Icons.inventory_2_outlined,
                          isActive: NavigationItems.product == section,
                        ),
                      ]),
                  Container()
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    topAppBar(),
                    Expanded(
                      child: switchBody,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topAppBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Visibility(
            visible: Responsive.isDesktop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 30.0),
              child: Text(
                "Admin Flutter",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Visibility(
            visible: Responsive.isMobile(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Image.asset("assets/logo.png", height: 50),
            ),
          ),
          Expanded(
            child: _nameAndProfilePicture(
              context,
              "Emily Smith",
              "https://image.freepik.com/free-photo/dreamy-girl-biting-sunglasses-looking-away-with-dreamy-face-purple-background_197531-7085.jpg",
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameAndProfilePicture(
      BuildContext context, String username, String imageUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(width: Styles.defaultPadding),
        NavigationButton(
          icon: Icons.logout,
          isActive: true,
          onPressed: () async {
            await logout().then((val) async {
              const storage = FlutterSecureStorage();
              storage.delete(key: "token");
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}

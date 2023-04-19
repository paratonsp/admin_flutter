// ignore_for_file: file_names

import 'package:admin_flutter/sections/product_list.dart';

import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          // Main Panel
          Expanded(
            child: ProductList(),
          ),
        ],
      ),
    );
  }
}

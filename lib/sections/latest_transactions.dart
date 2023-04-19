import 'package:admin_flutter/controller/product.dart';
import 'package:admin_flutter/models/product.dart';
import 'package:admin_flutter/responsive.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:admin_flutter/widgets/category_box.dart';
import 'package:flutter/material.dart';

class LatestTransactions extends StatefulWidget {
  const LatestTransactions({Key? key}) : super(key: key);

  @override
  State<LatestTransactions> createState() => _LatestTransactionsState();
}

class _LatestTransactionsState extends State<LatestTransactions> {
  final ScrollController _scrollController = ScrollController();
  bool isLoad = true;
  List<Product> product = [];

  getData() async {
    await getProduct(context).then((val) {
      if (val != null) {
        if (!mounted) return;
        setState(() {
          product = val;
          isLoad = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoad = false;
        });
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CategoryBox(
      title: "Latest Product",
      suffix: const SizedBox(),
      children: [
        Expanded(
          child: (isLoad)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : (product.isEmpty)
                  ? const Center(
                      child: Text("Empty Data"),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        var data = product[index];
                        return TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(
                                          Icons.inventory,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          data.nama_produk,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Styles.defaultPadding),
                                (Responsive.isDesktop(context))
                                    ? Expanded(
                                        flex: 3,
                                        child: Text(
                                          data.deskripsi,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(width: Styles.defaultPadding),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 80),
                                  padding:
                                      EdgeInsets.all(Styles.defaultPadding / 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Styles.defaultPadding / 2),
                                    color: (data.stok < 100)
                                        ? Styles.defaultRedColor
                                        : Styles.defaultBlueColor,
                                  ),
                                  child: Text(
                                    "${data.stok} Pcs",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {},
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

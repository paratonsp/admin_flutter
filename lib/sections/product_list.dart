// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:admin_flutter/controller/product.dart';
import 'package:admin_flutter/models/product.dart';
import 'package:admin_flutter/responsive.dart';
import 'package:admin_flutter/styles/styles.dart';
import 'package:admin_flutter/widgets/category_box.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
  bool isLoad = true;
  List<Product> product = [];

  getData() async {
    await getProduct(context).then((val) {
      if (val != null) {
        if (!mounted) return;
        setState(() {
          product = val;
          product.sort((a, b) => b.id.compareTo(a.id));
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
      title: "Products",
      suffix: TextButton(
        child: Text(
          "Create Product",
          style: TextStyle(
            color: Styles.defaultRedColor,
          ),
        ),
        onPressed: () {
          showModalForm(context, "Create Product", '', '', '', 0, 1, false);
        },
      ),
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
                        String img =
                            "https://is3.cloudhost.id/paratonsp-storage/no-image.png";
                        if (data.gambar != "") {
                          img = data.gambar;
                        }
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
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          img,
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
                          onPressed: () {
                            showModalForm(
                              context,
                              "Edit Product",
                              data.nama_produk,
                              data.deskripsi,
                              data.gambar,
                              data.id,
                              data.stok,
                              true,
                            );
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }

  void showModalForm(
    BuildContext context,
    String message,
    nama,
    deskripsi,
    gambar,
    int id,
    stok,
    bool isEdit,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: FormModalProduct(
                message: message,
                nama: nama,
                deskripsi: deskripsi,
                gambar: gambar,
                id: id,
                stok: stok,
                isEdit: isEdit));
      },
    ).then((value) {
      getData();
    });
  }
}

class FormModalProduct extends StatefulWidget {
  String message;
  String nama;
  String deskripsi;
  String gambar;
  int id;
  int stok;
  bool isEdit;
  FormModalProduct({
    Key? key,
    required this.message,
    required this.nama,
    required this.deskripsi,
    required this.gambar,
    required this.id,
    required this.stok,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<FormModalProduct> createState() => _FormModalProductState();
}

class _FormModalProductState extends State<FormModalProduct> {
  late TextEditingController namaController;
  late TextEditingController deskripsiController;
  late TextEditingController stokController;
  final formkey = GlobalKey<FormState>();

  String? gambar;

  String? fileName;
  String? filePath;
  List<PlatformFile>? file;

  saveFormProduct(
      isEdit, namaController, deskripsiController, stokController, id) async {
    (isEdit)
        ? await updateProduct(
            context,
            namaController.text,
            deskripsiController.text,
            stokController.text,
            id,
            fileName ??= '',
            filePath ??= '',
          ).then((val) {
            if (val == "Success") {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(val),
                duration: const Duration(seconds: 1),
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(val),
                duration: const Duration(seconds: 1),
              ));
            }
          })
        : await createProduct(
            context,
            namaController.text,
            deskripsiController.text,
            stokController.text,
            fileName ??= '',
            filePath ??= '',
          ).then(
            (val) {
              if (val == "Success") {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(val),
                  duration: const Duration(seconds: 1),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(val),
                  duration: const Duration(seconds: 1),
                ));
              }
            },
          );
  }

  deleteFormProduct(id) async {
    await deleteProduct(context, id).then((val) {
      if (val.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(val.body)["message"]),
          duration: const Duration(seconds: 1),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(val.body)["message"]),
          duration: const Duration(seconds: 1),
        ));
      }
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      file = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        lockParentWindow: false,
      ))
          ?.files;
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unsupported operation' + e.toString()),
        duration: const Duration(seconds: 1),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 1),
      ));
    }
    if (!mounted) return;
    setState(() {
      fileName = file != null ? file![0].name : '';
      filePath = file != null ? file![0].path : '';
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      fileName = null;
      filePath = null;
      file = null;
    });
  }

  @override
  void initState() {
    namaController = namaController = TextEditingController(text: widget.nama);
    deskripsiController =
        deskripsiController = TextEditingController(text: widget.deskripsi);
    stokController =
        stokController = TextEditingController(text: widget.stok.toString());
    if (widget.gambar != "") {
      gambar = widget.gambar;
    }
    super.initState();
  }

  @override
  void dispose() {
    try {
      namaController.dispose();
      deskripsiController.dispose();
      stokController.dispose();
    } catch (e) {
      log(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: 250, maxWidth: 250, maxHeight: 500),
      padding: EdgeInsets.all(Styles.defaultPadding),
      child: Form(
        key: formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.message,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                (widget.isEdit)
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Styles.defaultRedColor,
                        ),
                        splashRadius: 20,
                        onPressed: () {
                          deleteFormProduct(widget.id);
                        })
                    : const SizedBox(),
              ],
            ),
            SizedBox(height: Styles.defaultPadding),
            file != null
                ? GestureDetector(
                    onTap: () {
                      _pickFiles();
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Styles.defaultPadding),
                        image: DecorationImage(
                          image: FileImage(
                            File(filePath.toString()),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _pickFiles();
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Styles.defaultPadding),
                        image: DecorationImage(
                          image: NetworkImage(
                            gambar ??=
                                'https://is3.cloudhost.id/paratonsp-storage/no-image.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: Styles.defaultPadding),
            TextFormField(
              controller: namaController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "Name",
                labelText: "Name",
                border: InputBorder.none,
              ),
            ),
            TextFormField(
              controller: deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "Description",
                labelText: "Description",
                border: InputBorder.none,
              ),
            ),
            TextFormField(
              controller: stokController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product stock';
                }
                return null;
              },
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "Stock",
                labelText: "Stock",
                suffixText: "Pcs",
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: Styles.defaultPadding),
            SizedBox(
              width: 250,
              child: CupertinoButton.filled(
                  child: const Text("Save"),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      saveFormProduct(
                        widget.isEdit,
                        namaController,
                        deskripsiController,
                        stokController,
                        widget.id,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

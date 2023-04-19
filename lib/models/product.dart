import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class Product {
  final int id;
  final String nama_produk;
  final String deskripsi;
  final String gambar;
  final int stok;

  Product({
    required this.id,
    required this.nama_produk,
    required this.deskripsi,
    required this.gambar,
    required this.stok,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama_produk': nama_produk,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'stok': stok,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      nama_produk: map['nama_produk'] as String,
      deskripsi: map['deskripsi'] as String,
      gambar: map['gambar'] as String,
      stok: map['stok'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

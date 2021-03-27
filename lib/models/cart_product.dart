import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  String productId;
  int quantity;
  String size;
  String id;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ItemSize get itemSize {
    if (product == null) return null;
    return product.findSize(size);
  }

  ///preço do produto
  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  /// preço do produto X quantidade
  num get totalPrice => unitPrice * quantity;

  Product product;

  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  ///cria um cartProduct com o documento que veio do firebase
  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document.data()['pid'] as String;
    quantity = document.data()['quantity'] as int;
    size = document.data()['size'] as String;

    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners();
    });
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}

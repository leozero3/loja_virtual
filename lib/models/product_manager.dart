import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';

/// RECUPERA AS INFORMAÇOES DOS
/// PRODUTOS NO FIREBASE E SALVA
/// NA VARIAVEL 'allProduct' E
/// SALVA A FUNÇÃO '_loadAllProducts'
/// EM 'ProductManager' QUE É CHAMADA NA
/// 'main' ONDE É OBSERVADA AS MUDANÇAS

class ProductManager extends ChangeNotifier {
  ///var
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Product> allProducts = [];
  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot snapProducts =
        await firestore.collection('products').get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();

    // for(DocumentSnapshot doc in snapProducts.docs){
    //   print(doc.data());}

    notifyListeners();
  }

  ProductManager() {
    _loadAllProducts();
  }

  Product findProductById(String id){
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e){
      return null;
    }
    }

}

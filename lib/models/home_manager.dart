import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/section.dart';

class HomeManager extends ChangeNotifier{
  final Firestore firestore = Firestore.instance;

  HomeManager() {
    _loadSections();
  }

  List<Section> section = [];

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) {
      section.clear();
      for (final DocumentSnapshot document in snapshot.documents) {
        section.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }
}

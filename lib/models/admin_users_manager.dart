import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<Users> users = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription _subscription;

  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listentoUsers();
    } else{
      users.clear();
      notifyListeners();
    }
  }

  /// atualiza em tempo real
  void _listentoUsers() {
    _subscription = firestore.collection('users').snapshots().listen((snapshot){
      users = snapshot.docs.map((e) => Users.fromDocument(e)).toList();
      users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });
  }


  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// atualiza apenas quando abre o app
  // void _listentoUsers() {
  //   firestore.collection('users').get().then((snapshot){
  //     users = snapshot.docs.map((e) => Users.fromDocument(e)).toList();
  //     users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //     notifyListeners();
  //   });
  // }

  List<String> get names => users.map((e) => e.name).toList();
}

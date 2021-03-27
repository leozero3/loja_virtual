import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Users users;
  User user;

  bool _loading = false;

  bool get loading => _loading;

  bool get isLoggedIn => users != null;

  ///======================================================
  ///login
  Future<void> signIn(
      {Users users, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: users.email, password: users.password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  ///========================================================

  ///criar conta
  Future<void> signUp(
      {Users users, Function onFail, Function onSuccess}) async {
    loading = true;

    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: users.email, password: users.password);

      users.id = result.user.uid;
      users = users;

      await users.saveData();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  ///
  ///  sair

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  ///

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User firebaseUser}) async {
    final User currentuser = firebaseUser ?? auth.currentUser;
    if (currentuser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentuser.uid).get();
      users = Users.fromDocument(docUser);

      final docAdmin = await firestore.collection('admin').doc(users.id).get();
      if (docAdmin.exists) {
        users.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => users != null && users.admin;
}

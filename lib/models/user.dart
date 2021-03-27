import 'package:cloud_firestore/cloud_firestore.dart';

class Users {

  String id;
  String name;
  String email;
  String password;
  String confirmPassword;
  bool admin = false;

  Users({this.name, this.email, this.password, this.id});

  Users.fromDocument(DocumentSnapshot document) {

    id = document.id;
    name = document.data()['name'] as String;
    email = document.data()['email'] as String;
  }

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }



}

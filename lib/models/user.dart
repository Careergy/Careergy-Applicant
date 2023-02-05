import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User with ChangeNotifier {
  late final String uid;
  late final String fname;
  late final String lname;
  late final String email;
  late final String? phone;
  late final Image? photo;
  late final String? token;
  late final DateTime? accountCreationTime;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  User({
    required this.uid,
    required this.fname,
    required this.lname,
    required this.email,
    this.phone,
    this.photo,
    this.token,
    this.accountCreationTime,
  });

  Future getUserInfo(String uid) async {
    final ref = db.collection('users').doc(uid);
    ref.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data['name']);
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:careergy_mobile/models/user.dart' as usr;
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final usr.User? user;

  FirebaseAuth get auth {
    return _auth;
  }

  FirebaseFirestore get db {
    return _db;
  }

  //sign in with email & password
  Future login(String emailAddress, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //register
  Future signup(
      String emailAddress, String password, String phone, String name) async {
    try {
      final credential =
          await _auth.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );
      
      _db.collection('users').doc(credential.user!.uid).set({
        'name' : name,
        'email' : emailAddress,
        'phone' : phone
    });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //log out
  Future<void> logout() async {
    await _auth.signOut();
  }
}

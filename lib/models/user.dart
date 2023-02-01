import 'package:flutter/material.dart';

class User {

  late final String   uid;
  late final String   fname;
  late final String   lname;
  late final String   email;
  late final String?  phone;
  late final String?  photoUrl; 
  late final String?  token;

  User({required this.uid, required this.fname, required this.lname, required this.email, this.phone, this.photoUrl, this.token});



}
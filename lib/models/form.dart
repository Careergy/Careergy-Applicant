import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html';

class Form {
  late final String formID;
  // sender is applicant ID
  late final String sender;
  // reciever is company ID
  late final String reciever;
  late final String formTitle;
  late final String formBody;
  late final DateTime time = DateTime.now();

  Form(
      {required this.formID,
      required this.sender,
      required this.reciever,
      required this.formTitle,
      required this.formBody});

// when send button is clicked , this method will be triggered
  void sendForm(formId, sender, reciever, formTitle, formBody) {}

// get form by formID
  Future getFormByID(formID) async {}

// get all previous forms, then show them on "Email History" page
  Future getAllForms() async {
    return [];
  }
}

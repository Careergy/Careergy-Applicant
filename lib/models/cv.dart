import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html';

class CV {
  late final String cvID;
  late final File cvFile;

  // when upload button is clicked , this method will be triggered
  void uploadCV(cvID, cvFile) {}

  // update is deleting the old cv and replace it with new CV
  void updateCV(File NewCV) {}

  // when delete button is clicked , this method will be triggered
  void deleteCV(cvID) {}

  // show CV in the screen
  void showCV() {}

  // when download button is clicked , this method will be triggered
  void downloadCV() {}

  // get CV by ID from database
  Future getCVByID(cvID) async {
    return File([], "");
  }
}

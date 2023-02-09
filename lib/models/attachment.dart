import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html';

class Attachment {
  late final String attachmentID;
  late final File attachmentFile;

  // when add button is clicked , this method will be triggered
  void addAttahcment(attachmentID, attachmentFile) {}

  // when delete button is clicked, this method will be triggered
  void deleteAttachment(attachmentID) {}

  // get attahcment by ID from database
  Future getAttachmentByID() async {}

  // get all attachments from database
  Future getAllAttahcments() async {
    return [];
  }
}

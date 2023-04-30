import 'dart:io';
import 'dart:math';

import 'package:careergy_mobile/screens/attachment_preview.dart';
import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class AttatchmentsScreen extends StatefulWidget {
  const AttatchmentsScreen({super.key});

  @override
  State<AttatchmentsScreen> createState() => _AttatchmentsScreenState();
}

class _AttatchmentsScreenState extends State<AttatchmentsScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;
  final mainReference = FirebaseStorage.instance.ref('attachments/');

  List<dynamic> attachments_list = [];
  List<dynamic> attachments_ref_list = [];
  List<dynamic> attachments_format_list = [];

  Future<void> getUserAttachments(uid) async {
    EasyLoading.show(status: 'loading...');
    attachments_list.clear();
    attachments_ref_list.clear();
    attachments_format_list.clear();
    final storageRef = mainReference.child(uid);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      // print(item.fullPath);
      final last_slash = item.fullPath!.lastIndexOf('/');
      final doc_name = item.fullPath!.substring(last_slash + 1);
      final format =
          doc_name.substring(doc_name.lastIndexOf('.') + 1).toLowerCase();
      setState(() {
        attachments_list.add(doc_name);
        attachments_ref_list.add(item);
        attachments_format_list.add(format);
      });
    }
    EasyLoading.dismiss();
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getUserAttachments(user!.uid);
      // users.doc(user!.uid).snapshots().listen(
      //       (event) => getUserAttachments(user!.uid),
      //       onError: (error) => print("Listen failed: $error"),
      //     );
    });
  }

  // @override
  // void dispose() {
  //   // timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(title: 'Attachments'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              for (var i = 0; i < attachments_list.length; i++)
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    String url = await attachments_ref_list[i].getDownloadURL();
                    // print(attachments_ref_list[i]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttachmentPreview(
                                  doc_name: attachments_list[i],
                                  doc_url: url,
                                  doc_ref: attachments_ref_list[i],
                                ))).then((value) {
                      getUserAttachments(user!.uid);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 224, 224, 224),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        attachments_format_list[i] == 'pdf'
                            ? Icon(Icons.picture_as_pdf)
                            : attachments_format_list[i] == 'png' ||
                                    attachments_format_list[i] == 'jpeg' ||
                                    attachments_format_list[i] == 'jpg'
                                ? Icon(Icons.image)
                                : Icon(Icons.attach_file),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          attachments_list[i],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await FlutterDocumentPicker.openDocument();
          final last_slash = path!.lastIndexOf('/');
          final doc_name = path!.substring(last_slash + 1);
          if (path!.length > 0) {
            showAlertDialog(context, mainReference, user, path, doc_name);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showAlertDialog(
    BuildContext context,
    mainReference,
    user,
    path,
    doc_name,
  ) {
    // Create button
    Widget addButton = TextButton(
      child: Text("Add"),
      onPressed: () async {
        File file = File(path!);
        try {
          await mainReference.child(user!.uid).child(doc_name).putFile(file);
          setState(() {
            getUserAttachments(user!.uid);
          });
        } on FirebaseException catch (e) {
          // ...
          print(e);
        }
        Navigator.of(context).pop();
      },
    );

    Widget cancelButton = TextButton(
      child: Text("cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Adding file"),
      content:
          Text("Are you sure you want to add $doc_name to the attachments?"),
      actions: [cancelButton, addButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// void check() {
//   final user = FirebaseAuth.instance.currentUser;
//   print('added');
//   _AttatchmentsScreenState().getUserAttachments(user!.uid);
//   // getUserAttachments(user!.uid);
//   // added = false;
// }

// void getUserAttachments(uid) {}



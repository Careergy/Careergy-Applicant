// import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AttachmentPreview extends StatefulWidget {
  final String doc_name;
  final String doc_url;
  final Reference doc_ref;

  const AttachmentPreview({
    super.key,
    required this.doc_name,
    required this.doc_url,
    required this.doc_ref,
  });

  @override
  State<AttachmentPreview> createState() => _AttachmentPreviewState();
}

var deleted = false;

class _AttachmentPreviewState extends State<AttachmentPreview> {
  final user = FirebaseAuth.instance.currentUser;
  var doc_name = '';
  var doc_url = '';
  var format = '';
  var doc_ref;

  @override
  void initState() {
    super.initState();

    doc_name = widget.doc_name;
    doc_url = widget.doc_url;
    format = widget.doc_name
        .substring(widget.doc_name.lastIndexOf('.') + 1)
        .toLowerCase();
    doc_ref = widget.doc_ref;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlue,
          title: const Text('Attachment preview'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      doc_name,
                      style: const TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          showAlertDialog(context, doc_ref, user, doc_name);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        )),
                  ],
                ),
                format == 'png' || format == 'jpeg' || format == 'jpg'
                    ? Image.network(
                        doc_url,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : format == 'pdf'
                        ? SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SfPdfViewer.network(doc_url),
                          )
                        : const Text('File format unhandled'),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: TextButton(
                //             onPressed: () {
                //               showAlertDialog(context, doc_ref, user, doc_name);
                //               // if (deleted) {
                //               //   Navigator.pop(context);
                //               // }
                //             },
                //             child: Container(
                //               alignment: Alignment.center,
                //               padding: EdgeInsets.all(10),
                //               decoration: const BoxDecoration(
                //                   color: Color.fromARGB(255, 224, 224, 224),
                //                   borderRadius:
                //                       BorderRadius.all(Radius.circular(15))),
                //               height: 40,
                //               width: 150,
                //               child: const Text(
                //                 'Delete',
                //                 style: TextStyle(
                //                     color: Colors.red,
                //                     fontWeight: FontWeight.w600,
                //                     fontSize: 15),
                //               ),
                //             )),
                //       ),
                //     ],
                //   ),
                // )
              ]),
            ),
          ),
        ));
  }
}

showAlertDialog(BuildContext context, doc_ref, user, doc_name) {
  // Create button
  Widget deleteButton = TextButton(
    child: const Text("Delete"),
    onPressed: () async {
      print('delete');

      try {
        // Navigator.pop(context);
        Timer(const Duration(seconds: 1), () {
          Navigator.pop(context); // Dismisses dialog
          Navigator.pop(context); // Navigates back to previous screen
        });
        await doc_ref.delete();
        deleted = true;
      } on FirebaseException catch (e) {
        // Caught an exception from Firebase.
        print("Failed with error '${e.code}': ${e.message}");
      }
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Deleting file"),
    content:
        Text("Are you sure you want to delete $doc_name from the attachments?"),
    actions: [cancelButton, deleteButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

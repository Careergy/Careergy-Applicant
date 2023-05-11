import 'dart:async';

import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OverviewScreen extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String company_name;
  final List choosen_attachments_List;

  const OverviewScreen(
      {super.key,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location,
      required this.company_name,
      required this.choosen_attachments_List});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');
  final user = FirebaseAuth.instance.currentUser;

  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';

  String company_name = '';

  List<dynamic> choosen_attachments_List = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    company_uid = widget.company_uid;
    post_uid = widget.post_uid;
    post_image = widget.post_image;
    job_title = widget.job_title;
    descreption = widget.descreption;
    yearsOfExperience = widget.yearsOfExperience;
    location = widget.location;
    company_name = widget.company_name;
    choosen_attachments_List = widget.choosen_attachments_List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: canvasColor,
          title: const Text('Overview'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'job',
                          style: TextStyle(fontSize: 10),
                        ),
                        // Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        const Text(
                          'attachments',
                          style: TextStyle(fontSize: 10),
                        ),
                        // Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                        ),
                        const Text(
                          'agreements',
                          style: TextStyle(fontSize: 10),
                        ),
                        const Spacer(),
                        const Text(
                          'overview',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: canvasColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 2,
                              color: canvasColor),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: canvasColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 2,
                            color: canvasColor,
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: canvasColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 2,
                            color: canvasColor,
                          ),
                        ),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: canvasColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  width: MediaQuery.of(context).size.width - 70,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  post_image,
                                  // scale: 1,
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    company_name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    job_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                  // SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: canvasColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        '$yearsOfExperience years of experience',
                                        // maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: const [
                            Text(
                              'Job Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            // height: 200,
                            child: SingleChildScrollView(
                              child: Text(
                                descreption,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: const [
                              Text(
                                'Attachments',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height:
                              (MediaQuery.of(context).size.height / 1.8) / 5,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var i = 0;
                                    i < choosen_attachments_List.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 224, 224, 224),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      height: 30,
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200,
                                            child: Text(
                                              choosen_attachments_List[i],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    print('Apply');
                    applications
                        .where('applicant_uid', isEqualTo: user!.uid)
                        .where('post_uid', isEqualTo: post_uid)
                        .get()
                        .then((QuerySnapshot ds) async {
                      if (ds.docs.isEmpty) {
                        applications
                            .add({
                              'post_uid': post_uid,
                              'company_uid': company_uid,
                              'applicant_uid': user!.uid,
                              'attachments': choosen_attachments_List,
                              'status': 'pending',
                              'timestamp': DateTime.now().millisecondsSinceEpoch
                            })
                            .then((value) => {
                                  print("Applied"),
                                  EasyLoading.showSuccess('Applied succefully'),
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst),
                                })
                            .catchError((error) => {
                                  print("Failed to apply: $error"),
                                  EasyLoading.showError('Applied failed')
                                });
                      } else {
                        EasyLoading.showError('Already Applied');
                        print('already applied');
                      }
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: canvasColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ]),
        ));
  }
}

import 'dart:async';

import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart' as intl;

class AppliedOverviewScreen extends StatefulWidget {
  final String application_uid;
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String status;
  final String company_name;
  final int appointment_timestamp;
  final int last_updated_timestamp;
  final List choosen_attachments_List;

  const AppliedOverviewScreen(
      {super.key,
      required this.application_uid,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location,
      required this.status,
      required this.company_name,
      required this.appointment_timestamp,
      required this.last_updated_timestamp,
      required this.choosen_attachments_List});

  @override
  State<AppliedOverviewScreen> createState() => _AppliedOverviewScreenState();
}

class _AppliedOverviewScreenState extends State<AppliedOverviewScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');
  final user = FirebaseAuth.instance.currentUser;

  String application_uid = '';
  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';
  String status = '';
  int appointment_timestamp = 0;
  int last_updated_timestamp = 0;
  String formatted_timestamp = '';
  String formatted_last_updated = '';

  String company_name = '';

  List<dynamic> choosen_attachments_List = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    application_uid = widget.application_uid;
    company_uid = widget.company_uid;
    post_uid = widget.post_uid;
    post_image = widget.post_image;
    job_title = widget.job_title;
    descreption = widget.descreption;
    yearsOfExperience = widget.yearsOfExperience;
    location = widget.location;
    status = widget.status;
    company_name = widget.company_name;
    appointment_timestamp = widget.appointment_timestamp;
    last_updated_timestamp = widget.last_updated_timestamp;
    formatted_timestamp = intl.DateFormat('EEE, d MMM y | hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(widget.appointment_timestamp));
    formatted_last_updated = intl.DateFormat('EEE, d MMM y').format(
        DateTime.fromMillisecondsSinceEpoch(widget.last_updated_timestamp));
    choosen_attachments_List = widget.choosen_attachments_List;
    // print(widget.appointment_timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: canvasColor,
          title: const Text('Overview'),
        ),
        backgroundColor: accentCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status of job application',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: status == 'pending'
                                            ? Colors.grey
                                            : status == 'waiting'
                                                ? Colors.orangeAccent
                                                : status == 'accepted'
                                                    ? primaryColor
                                                    : status == 'approved'
                                                        ? Colors.green
                                                        : Colors.red),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: status == 'pending'
                                          ? Colors.grey
                                          : status == 'waiting'
                                              ? Colors.orangeAccent
                                              : status == 'accepted'
                                                  ? primaryColor
                                                  : status == 'approved'
                                                      ? Colors.green
                                                      : Colors.red),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'last updated: $formatted_last_updated',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          appointment_timestamp != 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      // height: 90,
                                      width: MediaQuery.of(context).size.width -
                                          50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Interview appointment date & time',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formatted_timestamp,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor),
                                          ),
                                          status == 'waiting'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          EasyLoading.show(
                                                              status:
                                                                  'accepting...');
                                                          applications
                                                              .doc(
                                                                  application_uid)
                                                              .update({
                                                                'status':
                                                                    'accepted',
                                                                'last_updated':
                                                                    DateTime.now()
                                                                        .millisecondsSinceEpoch
                                                              })
                                                              .then(
                                                                  (value) async =>
                                                                      {
                                                                        await EasyLoading.showSuccess(
                                                                            'Accepted succefully'),
                                                                        Timer(
                                                                            const Duration(seconds: 1),
                                                                            () {
                                                                          Navigator.of(context).popUntil((route) =>
                                                                              route.isFirst);
                                                                        }),
                                                                      })
                                                              .catchError((error,
                                                                      stackTrace) =>
                                                                  {
                                                                    EasyLoading
                                                                        .showError(
                                                                            'Failed'),
                                                                    print(
                                                                        error),
                                                                  });
                                                        },
                                                        child: Container(
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Colors.green,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20))),
                                                          child: const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          30),
                                                              child: Text(
                                                                'Accept',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          EasyLoading.show(
                                                              status:
                                                                  'rejecting...');
                                                          applications
                                                              .doc(
                                                                  application_uid)
                                                              .update({
                                                                'status':
                                                                    'refused',
                                                                'last_updated':
                                                                    DateTime.now()
                                                                        .millisecondsSinceEpoch
                                                              })
                                                              .then(
                                                                  (value) async =>
                                                                      {
                                                                        await EasyLoading.showSuccess(
                                                                            'Rejected succefully'),
                                                                        Timer(
                                                                            const Duration(seconds: 1),
                                                                            () {
                                                                          Navigator.of(context).popUntil((route) =>
                                                                              route.isFirst);
                                                                        }),
                                                                      })
                                                              .catchError((error,
                                                                      stackTrace) =>
                                                                  {
                                                                    EasyLoading
                                                                        .showError(
                                                                            'Failed'),
                                                                    print(
                                                                        error),
                                                                  });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: kBlue,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .red),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                          child: const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          30),
                                                              child: Text(
                                                                'Reject',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                        ))
                                                  ],
                                                )
                                              : status == 'accepted'
                                                  ? Row(
                                                      children: [
                                                        Text('Accepted')
                                                      ],
                                                    )
                                                  : status == 'refused'
                                                      ? Row(
                                                          children: [
                                                            Text('Accepted')
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Text(status)
                                                          ],
                                                        )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Text('')
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  // width: MediaQuery.of(context).size.width - 70,
                  decoration:
                      BoxDecoration(border: Border.all(color: canvasColor)),
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
                                        color: white),
                                  ),
                                  Text(
                                    job_title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
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
                                          color: primaryColor,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        '$yearsOfExperience years of experience',
                                        // maxLines: 1,
                                        // overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 9, color: white),
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: primaryColor),
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
                                style:
                                    const TextStyle(fontSize: 11, color: white),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
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
                                          color: titleBackground,
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
                                                  color: primaryColor,
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

                // TextButton(
                //   onPressed: () {
                //     print('Apply');
                //     applications
                //         .add({
                //           'post_uid': post_uid,
                //           'company_uid': company_uid,
                //           'applicant_uid': user!.uid,
                //           'attachments': choosen_attachments_List,
                //           'timestamp': DateTime.now().millisecondsSinceEpoch
                //         })
                //         .then((value) => {
                //               print("Applied"),
                //               Navigator.of(context)
                //                   .popUntil((route) => route.isFirst)
                //             })
                //         .catchError(
                //             (error) => print("Failed to apply: $error"));
                //   },
                //   child: Container(
                //     decoration: const BoxDecoration(
                //         color: canvasColor,
                //         borderRadius: BorderRadius.all(Radius.circular(20))),
                //     child: const Padding(
                //         padding:
                //             EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                //         child: Text(
                //           'Apply',
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold),
                //         )),
                //   ),
                // ),
              ]),
        ));
  }
}

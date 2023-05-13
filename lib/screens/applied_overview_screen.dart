import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AppliedOverviewScreen extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String status;
  final String company_name;
  final List choosen_attachments_List;

  const AppliedOverviewScreen(
      {super.key,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location,
      required this.status,
      required this.company_name,
      required this.choosen_attachments_List});

  @override
  State<AppliedOverviewScreen> createState() => _AppliedOverviewScreenState();
}

class _AppliedOverviewScreenState extends State<AppliedOverviewScreen> {
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
  String status = '';

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
    status = widget.status;
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
        backgroundColor: accentCanvasColor,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      'Status of job application',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        status,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
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

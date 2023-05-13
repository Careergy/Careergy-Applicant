import 'package:careergy_mobile/screens/apply_for_company-scnd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart' as intl;

import '../constants.dart';

class ApplyForCompanyScreen extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;
  final String major;
  final String type;
  final String timestamp;

  const ApplyForCompanyScreen({
    super.key,
    required this.company_uid,
    required this.post_uid,
    required this.post_image,
    required this.job_title,
    required this.descreption,
    required this.yearsOfExperience,
    required this.location,
    required this.major,
    required this.type,
    required this.timestamp,
  });

  @override
  State<ApplyForCompanyScreen> createState() => _ApplyForCompanyScreenState();
}

class _ApplyForCompanyScreenState extends State<ApplyForCompanyScreen> {
  CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');
  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';
  String major = '';
  String type = '';
  String timestamp = '';
  String formatted_timestamp = '';

  String company_name = '';

  Future<void> getPostInfo(String uid) async {
    companies.doc(uid).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          company_name =
              ds.data().toString().contains('name') ? ds.get('name') : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPostInfo(widget.company_uid);
    company_uid = widget.company_uid;
    post_uid = widget.post_uid;
    post_image = widget.post_image;
    job_title = widget.job_title;
    descreption = widget.descreption;
    yearsOfExperience = widget.yearsOfExperience;
    location = widget.location;
    major = widget.major;
    type = widget.type;
    timestamp = widget.timestamp;
    formatted_timestamp = intl.DateFormat('EEE, d MMM y | hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(widget.timestamp)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('Job Applications'),
      ),
      backgroundColor: accentCanvasColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
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
                Flexible(
                  child: SizedBox(
                    // width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              company_name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: white),
                            ),
                            // Spacer(),
                          ],
                        ),
                        Text(
                          job_title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor),
                        ),
                        Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        // SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              '$yearsOfExperience Years of experience',
                              maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontSize: 13, color: white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            divider,
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatted_timestamp,
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
            const Text(
              'Major',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              major,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: white),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Job type',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: white),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Job Description',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Expanded(
              child: Container(
                // height: 200,
                child: SingleChildScrollView(
                  child: Text(descreption,
                      style: const TextStyle(
                        color: white,
                      )),
                ),
              ),
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    print('brief cv button');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApplyForCompanyScnd(
                                company_name: company_name,
                                company_uid: company_uid,
                                descreption: descreption,
                                job_title: job_title,
                                location: location,
                                post_image: post_image,
                                post_uid: post_uid,
                                yearsOfExperience: yearsOfExperience,
                                type: type,
                                formatted_timestamp: formatted_timestamp,
                                major: major)));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    // color: Colors.blue,
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
                  )),
            )
            // const Text(
            //   'CV',
            //   style: TextStyle(
            //       color: canvasColor, fontSize: 26.0, fontWeight: FontWeight.bold),
            // )
          ],
        ),
      ),
    );
  }
}

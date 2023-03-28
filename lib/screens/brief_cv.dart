import 'dart:ffi';

import 'package:careergy_mobile/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/custom_textfieldform.dart';

class BriefCV extends StatefulWidget {
  const BriefCV({super.key});

  @override
  State<BriefCV> createState() => _BriefCVState();
}

class _BriefCVState extends State<BriefCV> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference keywords =
      FirebaseFirestore.instance.collection('keywords');
  CollectionReference briefcvs =
      FirebaseFirestore.instance.collection('briefcvs');
  // Initial Selected Value
  String intrests_val = 'none';
  String job_titles_val = 'none';
  String major_skills_val = 'none';
  String soft_skills_val = 'none';
  String other_skills_val = 'none';

  var intrests = ['none'];
  var job_titles = ['none'];
  var major_skills = ['none'];
  var soft_skills = ['none'];
  var other_skills = ['none'];

  late TextEditingController other_skills_controller;

  void getBriefcvInfo() {
    keywords.doc('intrests').get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        // print('Document data: ${ds.data()}');
        setState(() {
          intrests = ds.data().toString().contains('keys')
              ? ds.get('keys').cast<String>()
              : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    keywords.doc('job_titles').get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          job_titles = ds.data().toString().contains('keys')
              ? ds.get('keys').cast<String>()
              : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    keywords.doc('major_skills').get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          major_skills = ds.data().toString().contains('keys')
              ? ds.get('keys').cast<String>()
              : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    keywords.doc('soft_skills').get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          soft_skills = ds.data().toString().contains('keys')
              ? ds.get('keys').cast<String>()
              : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    other_skills_controller = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      getBriefcvInfo();
      print("Build Completed");
    });
  }

  @override
  void dispose() {
    other_skills_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: const Text('Brief CV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Let us know you better !',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Job title',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    value: job_titles_val,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: job_titles.map((String job_titles) {
                      return DropdownMenuItem(
                        value: job_titles,
                        child: Text(job_titles),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        job_titles_val = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Intrests',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    value: intrests_val,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: intrests.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        intrests_val = newValue!;
                      });
                      print(job_titles.toString());
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Major skills',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    value: major_skills_val,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: major_skills.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        major_skills_val = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Soft skills',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: [
                  DropdownButton(
                    value: soft_skills_val,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: soft_skills.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        soft_skills_val = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Other',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )
                ],
              ),
              TextField(
                // obscureText: true,
                onChanged: (text) {
                  other_skills_val = text;
                },
                decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    // labelText: 'Input',
                    constraints: BoxConstraints(maxHeight: 30)),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
                    print('breif cv add button');
                    briefcvs
                        .doc(user!.uid)
                        .set({
                          'job_title': [job_titles_val],
                          'intrests': [intrests_val],
                          'major_skills': [major_skills_val],
                          'soft_skills': [soft_skills_val],
                          'other': [other_skills_val],
                        })
                        .then((value) => {
                              print("User Updated"),
                              Navigator.pop(context),
                            })
                        .catchError(
                            (error) => print("Failed to update user: $error"));
                    ;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    // color: Colors.blue,
                    child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                        child: Text(
                          'Save',
                          // style: TextStyle(color: Colors.white),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

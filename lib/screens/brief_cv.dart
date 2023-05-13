// import 'dart:ffi';

import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/widgets/briefcv_field.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as usr;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../widgets/custom_textfieldform.dart';

class BriefCV extends StatefulWidget {
  const BriefCV({super.key});

  @override
  State<BriefCV> createState() => _BriefCVState();
}

class _BriefCVState extends State<BriefCV> {
  // final user = FirebaseAuth.instance.currentUser;
  // CollectionReference keywords =
  //     FirebaseFirestore.instance.collection('keywords');
  // CollectionReference briefcvs =
  //     FirebaseFirestore.instance.collection('briefcvs');
  // // Initial Selected Value
  // String intrests_val = 'none';
  // String job_titles_val = 'none';
  // String major_skills_val = 'none';
  // String soft_skills_val = 'none';
  // String other_skills_val = 'none';

  // var intrests = ['none'];
  // var job_titles = ['none'];
  // var major_skills = ['none'];
  // var soft_skills = ['none'];
  // var other_skills = ['none'];

  // void getBriefcvInfo() {
  //   keywords.doc('intrests').get().then((DocumentSnapshot ds) {
  //     if (ds.exists) {
  //       // print('Document data: ${ds.data()}');
  //       setState(() {
  //         intrests = ds.data().toString().contains('keys')
  //             ? ds.get('keys').cast<String>()
  //             : '';
  //       });
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  //   keywords.doc('job_titles').get().then((DocumentSnapshot ds) {
  //     if (ds.exists) {
  //       setState(() {
  //         job_titles = ds.data().toString().contains('keys')
  //             ? ds.get('keys').cast<String>()
  //             : '';
  //       });
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  //   keywords.doc('major_skills').get().then((DocumentSnapshot ds) {
  //     if (ds.exists) {
  //       setState(() {
  //         major_skills = ds.data().toString().contains('keys')
  //             ? ds.get('keys').cast<String>()
  //             : '';
  //       });
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  //   keywords.doc('soft_skills').get().then((DocumentSnapshot ds) {
  //     if (ds.exists) {
  //       setState(() {
  //         soft_skills = ds.data().toString().contains('keys')
  //             ? ds.get('keys').cast<String>()
  //             : '';
  //       });
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   other_skills_controller = TextEditingController();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     // do something
  //     getBriefcvInfo();
  //     print("Build Completed");
  //   });
  // }

  // @override
  // void dispose() {
  //   other_skills_controller.dispose();
  //   super.dispose();
  // }

  TextfieldTagsController majorsController = TextfieldTagsController();
  TextfieldTagsController jobTitleController = TextfieldTagsController();
  TextfieldTagsController majorSkillsController = TextfieldTagsController();
  TextfieldTagsController softSkillsController = TextfieldTagsController();
  TextfieldTagsController interestsController = TextfieldTagsController();
  TextfieldTagsController otherSkillsController = TextfieldTagsController();
  TextfieldTagsController locationsController = TextfieldTagsController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<usr.User>(context);
    // if (user.breifcvExists) {
    //   jobTitleController.
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('Brief CV'),
      ),
      backgroundColor: accentCanvasColor,
      body: FutureBuilder(
          future: user.getBriefCV(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // print(user.briefcv!['job_title']);
              return Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let us know you better !',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: accentPrimaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Majors:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Majors:',
                        keysName: 'majors',
                        controller: majorsController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['majors'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Job Titles:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Job Titles:',
                        keysName: 'job_titles',
                        controller: jobTitleController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['job_title'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Major Skills:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Major Skills:',
                        keysName: 'major_skills',
                        controller: majorSkillsController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['major_skills'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Soft Skills:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Soft Skills:',
                        keysName: 'soft_skills',
                        controller: softSkillsController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['soft_skills'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Interests:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Interests:',
                        keysName: 'intrests',
                        controller: interestsController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['intrests'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Other Skills:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Other Skills:',
                        helper: '*Skills are separated using a Comma (,)',
                        controller: otherSkillsController,
                        mode: false,
                        separaters: const [','],
                        initialTags: user.breifcvExists
                            ? user.briefcv!['other_skills'] as List<String>
                            : [],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Prefered Locations:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2.5,
                      ),
                      BriefCVField(
                        label: 'Prefered Locations:',
                        keysName: 'locations',
                        controller: locationsController,
                        initialTags: user.breifcvExists
                            ? user.briefcv!['prefered_locations']
                                as List<String>
                            : [],
                      ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: const [
                      //     Text(
                      //       'Job title',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           color: Colors.blue),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     DropdownButton(
                      //       value: job_titles_val,
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //       items: job_titles.map((String job_titles) {
                      //         return DropdownMenuItem(
                      //           value: job_titles,
                      //           child: Text(job_titles),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           job_titles_val = newValue!;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: const [
                      //     Text(
                      //       'Intrests',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           color: Colors.blue),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     DropdownButton(
                      //       value: intrests_val,
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //       items: intrests.map((String items) {
                      //         return DropdownMenuItem(
                      //           value: items,
                      //           child: Text(items),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           intrests_val = newValue!;
                      //         });
                      //         print(job_titles.toString());
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: const [
                      //     Text(
                      //       'Major skills',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           color: Colors.blue),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     DropdownButton(
                      //       value: major_skills_val,
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //       items: major_skills.map((String items) {
                      //         return DropdownMenuItem(
                      //           value: items,
                      //           child: Text(items),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           major_skills_val = newValue!;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: const [
                      //     Text(
                      //       'Soft skills',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           color: Colors.blue),
                      //     )
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     DropdownButton(
                      //       value: soft_skills_val,
                      //       icon: const Icon(Icons.keyboard_arrow_down),
                      //       items: soft_skills.map((String items) {
                      //         return DropdownMenuItem(
                      //           value: items,
                      //           child: Text(items),
                      //         );
                      //       }).toList(),
                      //       onChanged: (String? newValue) {
                      //         setState(() {
                      //           soft_skills_val = newValue!;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: const [
                      //     Text(
                      //       'Other skills',
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //           color: Colors.blue),
                      //     )
                      //   ],
                      // ),
                      // TextField(
                      //   // obscureText: true,
                      //   onChanged: (text) {
                      //     other_skills_val = text;
                      //   },
                      //   decoration: const InputDecoration(
                      //       // border: OutlineInputBorder(),
                      //       // labelText: 'Input',
                      //       constraints: BoxConstraints(maxHeight: 30)),
                      // ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextButton(
                          onPressed: () async {
                            // print('breif cv add button');
                            // briefcvs
                            //     .doc(user!.uid)
                            //     .set({
                            //       'job_title': [job_titles_val],
                            //       'intrests': [intrests_val],
                            //       'major_skills': [major_skills_val],
                            //       'soft_skills': [soft_skills_val],
                            //       'other_skills': [other_skills_val],
                            //     })
                            //     .then((value) => {
                            //           print("User Updated"),
                            //           Navigator.pop(context),
                            //         })
                            //     .catchError(
                            //         (error) => print("Failed to update user: $error"));
                            // ;
                            // print(otherSkillsController.getTags);

                            setState(() {
                              isLoading = true;
                            });

                            user.briefcv = {
                              'majors': majorsController.getTags,
                              'job_title': jobTitleController.getTags,
                              'major_skills': majorSkillsController.getTags,
                              'soft_skills': softSkillsController.getTags,
                              'intrests': interestsController.getTags,
                              'other_skills': otherSkillsController.getTags,
                              'prefered_locations': locationsController.getTags
                            };

                            await user.setBriefCV();

                            setState(() {
                              isLoading = false;
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            // color: Colors.blue,
                            child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 100),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: primaryColor),
                                )),
                          ))
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}

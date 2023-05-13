import 'package:careergy_mobile/screens/applied_overview_screen.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'apply_for_company_Screen.dart';

class AppliedScreen extends StatefulWidget {
  const AppliedScreen({super.key});

  @override
  State<AppliedScreen> createState() => _AppliedScreenState();
}

class _AppliedScreenState extends State<AppliedScreen> {
  final user = FirebaseAuth.instance.currentUser;

  String note = '';

  List applications = [];
  List applications_uid = [];

  List applied_posts = [];
  List applied_posts_uid = [];
  List company_names = [];
  List company_photos = [];

  bool finish = false;

  Future getApplications() async {
    // Get docs from collection reference
    Query<Map<String, dynamic>> posts_ref = await FirebaseFirestore.instance
        .collection("applications")
        .where('applicant_uid', isEqualTo: user!.uid)
        .orderBy("timestamp", descending: true);
    QuerySnapshot querySnapshot = await posts_ref.get();

    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataUid =
        querySnapshot.docs.map((doc) => doc.reference.id).toList();
    setState(() {
      applications = allData;
      applications_uid = allDataUid;
    });
    // print(applications);
  }

  Future getAppliedPosts() async {
    CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    for (var i = 0; i < applications.length; i++) {
      DocumentReference<Map<String, dynamic>> posts_ref =
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(applications[i]['post_uid']);
      // .where('active', isEqualTo: true)
      // .orderBy("timestamp", descending: true);

      await posts_ref.get().then(
        (DocumentSnapshot doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final allDataUid = doc.reference.id;
          setState(() {
            applied_posts.add(data);
            applied_posts_uid.add(allDataUid);
          });
          // print(applied_posts);
          await companies.doc(data['uid']).get().then((DocumentSnapshot ds) {
            if (ds.exists) {
              setState(() {
                company_names.add(ds.data().toString().contains('name')
                    ? ds.get('name')
                    : '');
                company_photos.add(ds.data().toString().contains('photoUrl')
                    ? ds.get('photoUrl')
                    : '');
              });
            } else {
              print('Document does not exist on the database');
            }
          });
          // name = data['name'] ?? '';
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
    if (applications.isEmpty) {
      setState(() {
        note = 'You have no applied jobs';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: 'loading...');
      await getApplications();
      await getAppliedPosts();
      setState(() {
        finish = true;
      });
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Applications'),
      backgroundColor: accentCanvasColor,
      body: applied_posts.isNotEmpty && finish
          ? SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                          // margin: const EdgeInsets.symmetric(vertical: 20.0),
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            children: List.generate(applications.length, (i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppliedOverviewScreen(
                                              application_uid:
                                                  applications_uid[i],
                                              company_uid: applied_posts[i]
                                                  ['uid'],
                                              post_uid: applied_posts_uid[i],
                                              post_image: company_photos[i],
                                              job_title: applied_posts[i]
                                                  ['job_title'],
                                              descreption: applied_posts[i]
                                                  ['descreption'],
                                              yearsOfExperience:
                                                  applied_posts[i]
                                                      ['experience_years'],
                                              location: applied_posts[i]
                                                  ['city'],
                                              status: applications[i]['status'],
                                              choosen_attachments_List:
                                                  applications[i]
                                                      ['attachments'],
                                              company_name: company_names[i],
                                              appointment_timestamp: applications[
                                                          i][
                                                      'appointment_timestamp'] ??
                                                  0,
                                              last_updated_timestamp:
                                                  applications[i]
                                                          ['last_updated'] ??
                                                      0,
                                            )),
                                  ).then((value) {
                                    print('object');
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 240,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: canvasColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.network(
                                                company_photos.isNotEmpty
                                                    ? company_photos[i]
                                                    : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
                                                // scale: 1,
                                                // fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    applied_posts[i]
                                                        ['job_title'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    applied_posts[i]
                                                        ['descreption'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: white),
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '${applied_posts[i]['experience_years']} years of experience',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        // fontWeight: FontWeight,
                                                        color: white),
                                                  ),
                                                  Text(
                                                    'Lcation: ${applied_posts[i]['city']}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: applications[
                                                                            i][
                                                                        'status'] ==
                                                                    'pending'
                                                                ? Colors.grey
                                                                : applications[i][
                                                                            'status'] ==
                                                                        'waiting'
                                                                    ? Colors
                                                                        .orangeAccent
                                                                    : applications[i]['status'] ==
                                                                            'accepted'
                                                                        ? primaryColor
                                                                        : applications[i]['status'] ==
                                                                                'approved'
                                                                            ? Colors
                                                                                .green
                                                                            : Colors
                                                                                .red),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    15))),
                                                    child: Text(
                                                      applications[i]['status'],
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: applications[i]
                                                                      [
                                                                      'status'] ==
                                                                  'pending'
                                                              ? Colors.grey
                                                              : applications[i][
                                                                          'status'] ==
                                                                      'waiting'
                                                                  ? Colors
                                                                      .orangeAccent
                                                                  : applications[i]
                                                                              [
                                                                              'status'] ==
                                                                          'accepted'
                                                                      ? primaryColor
                                                                      : applications[i]['status'] ==
                                                                              'approved'
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )),
                    ],
                  )),
            )
          : Center(
              child: Text(note, style: const TextStyle(color: primaryColor))),
    );
  }
}

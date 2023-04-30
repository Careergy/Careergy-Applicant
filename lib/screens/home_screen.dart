import 'dart:async';

import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/providers/auth_provider.dart';
// import 'package:careergy_mobile/screens/apply_for_company_screen.dart';
import 'package:careergy_mobile/screens/company_profile.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'apply_for_company_Screen.dart';
// import 'package:riverpod/riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final authRef = ref.watch(auth);
  final user = FirebaseAuth.instance.currentUser;

  List recent_posts = [];
  List recent_posts_uid = [];

  List recommended_posts = [];
  List recommended_posts_uid = [];

  Future getRecentPosts() async {
    // Get docs from collection reference
    Query<Map<String, dynamic>> posts_ref = await FirebaseFirestore.instance
        .collection("posts")
        .where('active', isEqualTo: true)
        .orderBy("timestamp", descending: true);
    QuerySnapshot querySnapshot = await posts_ref.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataUid =
        querySnapshot.docs.map((doc) => doc.reference.id).toList();
    setState(() {
      recent_posts = allData;
      recent_posts_uid = allDataUid;
    });
    // print(allDataUid);
  }

  Future getRecomendedPosts() async {
    // Get docs from collection reference
    Query<Map<String, dynamic>> posts_ref = await FirebaseFirestore.instance
        .collection("posts")
        .where('active', isEqualTo: true)
        .where('major', isEqualTo: 'software engineering')
        .orderBy("timestamp", descending: true);
    QuerySnapshot querySnapshot = await posts_ref.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataUid =
        querySnapshot.docs.map((doc) => doc.reference.id).toList();
    setState(() {
      recommended_posts = allData;
      recommended_posts_uid = allDataUid;
    });
    // print(allDataUid);
  }

  Future getLogo(String uid) async {
    //TODO: Get image from the uid of getPosts
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getRecentPosts();
      await getRecomendedPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, ...!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const Text(
                  'apply now, and find your job!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Recent Jobs',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                recent_posts.isNotEmpty
                    ? SizedBox(
                        // margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 120.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(recent_posts.length, (i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplyForCompanyScreen(
                                            company_uid: recent_posts[i]['uid'],
                                            post_uid: recent_posts_uid[i],
                                            post_image: '',
                                            job_title: recent_posts[i]
                                                ['job_title'],
                                            descreption: recent_posts[i]
                                                ['descreption'],
                                            yearsOfExperience: recent_posts[i]
                                                ['experience_years'],
                                            location: recent_posts[i]['city'],
                                          )),
                                ).then((value) {
                                  print('object');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 240,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
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
                                            child: Image.asset(
                                              'assets/images/jahez.png',
                                              // scale: 1,
                                              // fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
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
                                                  recent_posts[i]['job_title'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  recent_posts[i]
                                                      ['descreption'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${recent_posts[i]['experience_years']} years of experience',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      // fontWeight: FontWeight,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'Lcation: ${recent_posts[i]['city']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ))
                    : const Text('Empty'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Recommended Jobs',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                ),
                recommended_posts.isNotEmpty
                    ? SizedBox(
                        // margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 120.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(recommended_posts.length, (i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ApplyForCompanyScreen(
                                            company_uid: recommended_posts[i]
                                                ['uid'],
                                            post_uid: recommended_posts_uid[i],
                                            post_image: '',
                                            job_title: recommended_posts[i]
                                                ['job_title'],
                                            descreption: recommended_posts[i]
                                                ['descreption'],
                                            yearsOfExperience:
                                                recommended_posts[i]
                                                    ['experience_years'],
                                            location: recommended_posts[i]
                                                ['city'],
                                          )),
                                ).then((value) {
                                  print('object');
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 240,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
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
                                            child: Image.asset(
                                              'assets/images/jahez.png',
                                              // scale: 1,
                                              // fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
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
                                                  recommended_posts[i]
                                                      ['job_title'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  recommended_posts[i]
                                                      ['descreption'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '${recommended_posts[i]['experience_years']} years of experience',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      // fontWeight: FontWeight,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'Lcation: ${recommended_posts[i]['city']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ))
                    : const Text('Empty'),
              ],
            ),

            // const Text(
            //   'Home Screen',
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     auth.logout();
            //   },
            //   child: const Text('log out'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => ApplyForCompanyScreen()));
            //   },
            //   child: const Text('This is a company'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => CompanyProfile()));
            //   },
            //   child: const Text('a company profile example'),
            // )
          ],
        ),
      ),
    );
  }
}

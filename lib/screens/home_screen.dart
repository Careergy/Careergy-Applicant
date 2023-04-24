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

  List posts = [];
  List posts_uid = [];

  Future getPosts() async {
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
      posts = allData;
      posts_uid = allDataUid;
    });
    // print(allDataUid);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPosts();
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
            posts.isNotEmpty
                ? SizedBox(
                    // margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 120.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(posts.length, (i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApplyForCompanyScreen(
                                        company_uid: posts[i]['uid'],
                                        post_uid: posts_uid[i],
                                        post_image: '',
                                        job_title: posts[i]['job_title'],
                                        descreption: posts[i]['descreption'],
                                        yearsOfExperience: posts[i]
                                            ['experience_years'],
                                        location: posts[i]['city'],
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              posts[i]['job_title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              posts[i]['descreption'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '${posts[i]['experience_years']} years of experience',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  // fontWeight: FontWeight,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              'Lcation: ${posts[i]['city']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
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
                      }
                          // [
                          //   Container(
                          //     width: 220,
                          //     decoration: BoxDecoration(
                          //         color: Colors.blue[100],
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(15))),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Row(
                          //             children: [
                          //               const Text('image'),
                          //               Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Column(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.center,
                          //                   children: [
                          //                     Text(
                          //                       posts[0]['city'],
                          //                       style: const TextStyle(
                          //                           fontSize: 18,
                          //                           color: Colors.white),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          //   Container(
                          //     width: 200,
                          //     color: Colors.purple[600],
                          //     child: Center(
                          //         child: Text(
                          //       posts[0]['city'],
                          //       style: TextStyle(fontSize: 18, color: Colors.white),
                          //     )),
                          //   ),
                          // ],
                          ),
                    ))
                : const Text('Empty'),

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

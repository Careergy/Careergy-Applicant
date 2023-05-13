import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/company_about_profile.dart';
import 'package:careergy_mobile/screens/company_jobs_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'apply_for_company_Screen.dart';

class CompanyProfile extends StatefulWidget {
  final String companyName;
  final List jobs;
  final String bio;
  final String image;
  final String email;
  final String phone;
  final String uid;

  const CompanyProfile({
    required this.companyName,
    required this.jobs,
    required this.bio,
    required this.image,
    Key? key,
    required this.email,
    required this.phone,
    required this.uid,
  }) : super(key: key);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List posts = [];
  List posts_uid = [];
  List posts_photos = [];
  String recent_posts_note = '';

  Future getCompanyPosts() async {
    // Get docs from collection reference
    Query<Map<String, dynamic>> posts_ref = await FirebaseFirestore.instance
        .collection("posts")
        .where('active', isEqualTo: true)
        .where('uid', isEqualTo: widget.uid)
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
    if (posts.isEmpty) {
      recent_posts_note = 'No recent posts found';
    }
    CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    for (var i = 0; i < posts_uid.length; i++) {
      await companies.doc(posts[i]['uid']).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            posts_photos.add(ds.data().toString().contains('photoUrl')
                ? ds.get('photoUrl')
                : '');
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: 'loading...');
      await getCompanyPosts();
      EasyLoading.dismiss();
    });
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
        backgroundColor: canvasColor,
      ),
      backgroundColor: accentCanvasColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.image,
                        // scale: 1,
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.companyName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                TabBar(
                  labelColor: primaryColor,
                  unselectedLabelColor: white,
                  controller: _tabController,
                  tabs: [
                    Tab(text: ('About')),
                    Tab(text: 'Jobs'),
                    Tab(text: 'Contact us')
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.bio,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(posts.length, (i) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApplyForCompanyScreen(
                                                  company_uid: posts[i]['uid'],
                                                  post_uid: posts_uid[i],
                                                  post_image: posts_photos[i],
                                                  job_title: posts[i]
                                                      ['job_title'],
                                                  descreption: posts[i]
                                                      ['descreption'],
                                                  yearsOfExperience: posts[i]
                                                      ['experience_years'],
                                                  location: posts[i]['city'],
                                                  major: posts[i]['major'],
                                                  type: posts[i]['type'],
                                                  timestamp: posts[i]
                                                      ['timestamp'],
                                                )),
                                      ).then((value) {
                                        print('object');
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        // width: 240,
                                        // height: 100,
                                        decoration: BoxDecoration(
                                            color: canvasColor,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    posts_photos.isNotEmpty &&
                                                            i <
                                                                posts_photos
                                                                    .length
                                                        ? posts_photos[i]
                                                        : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        posts[i]['job_title'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        posts[i]['descreption'],
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: white),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        '${posts[i]['experience_years']} years of experience',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            // fontWeight: FontWeight,
                                                            color: white),
                                                      ),
                                                      Text(
                                                        'Lcation: ${posts[i]['city']}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: white),
                                                      ),
                                                      Text(
                                                        posts[i]['major'],
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: white),
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
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email_outlined, color: primaryColor),
                                SizedBox(width: 16),
                                Text(
                                  widget.email,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.phone, color: primaryColor),
                                SizedBox(width: 16),
                                Text(
                                  widget.phone,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:careergy_mobile/screens/apply_for_company_Screen.dart';
import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class RecentJobs extends StatefulWidget {
  final List recent_posts;
  final List recent_posts_uid;
  final List recent_posts_photos;
  // final String doc_url;
  // final Reference doc_ref;

  const RecentJobs({
    super.key,
    required this.recent_posts,
    required this.recent_posts_uid,
    required this.recent_posts_photos,
  });

  @override
  State<RecentJobs> createState() => _RecentJobsState();
}

var deleted = false;

class _RecentJobsState extends State<RecentJobs> {
  final user = FirebaseAuth.instance.currentUser;
  var recent_posts = [];
  var recent_posts_uid = [];
  var recent_posts_photos = [];
  // var doc_ref;

  @override
  void initState() {
    super.initState();

    recent_posts = widget.recent_posts;
    recent_posts_uid = widget.recent_posts_uid;
    recent_posts_photos = widget.recent_posts_photos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: canvasColor,
          title: const Text('Recent jobs'),
        ),
        backgroundColor: accentCanvasColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(children: [
                SizedBox(
                    // margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(recent_posts.length, (i) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApplyForCompanyScreen(
                                        company_uid: recent_posts[i]['uid'],
                                        post_uid: recent_posts_uid[i],
                                        post_image: recent_posts_photos[i],
                                        job_title: recent_posts[i]['job_title'],
                                        descreption: recent_posts[i]
                                            ['descreption'],
                                        yearsOfExperience: recent_posts[i]
                                            ['experience_years'],
                                        location: recent_posts[i]['city'],
                                        major: recent_posts[i]['major'],
                                        type: recent_posts[i]['type'],
                                        timestamp: recent_posts[i]['timestamp'],
                                      )),
                            ).then((value) {
                              print('object');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              // width: 240,
                              // height: 100,
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
                                          recent_posts_photos.isNotEmpty &&
                                                  i < recent_posts_photos.length
                                              ? recent_posts_photos[i]
                                              : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
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
                                              recent_posts[i]['job_title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: white),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              recent_posts[i]['descreption'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: white),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${recent_posts[i]['experience_years']} years of experience',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  // fontWeight: FontWeight,
                                                  color: white),
                                            ),
                                            Text(
                                              'Lcation: ${recent_posts[i]['city']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: white),
                                            ),
                                            Text(
                                              recent_posts[i]['major'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
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
                    ))
              ]),
            ),
          ),
        ));
  }
}

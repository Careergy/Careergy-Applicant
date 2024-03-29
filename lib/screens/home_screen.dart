import 'dart:async';
import 'dart:ffi';

import 'package:careergy_mobile/models/user.dart' as usr;
import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/providers/auth_provider.dart';
// import 'package:careergy_mobile/screens/apply_for_company_screen.dart';
import 'package:careergy_mobile/screens/company_profile.dart';
import 'package:careergy_mobile/screens/recent_jobs_screen.dart';
import 'package:careergy_mobile/widgets/briefcv_field.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:careergy_mobile/widgets/theme.dart';
import 'apply_for_company_Screen.dart';
import 'package:card_loading/card_loading.dart';
// import 'package:riverpod/riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final authRef = ref.watch(auth);
  final user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot<Map<String, dynamic>>> userAppliedStream =
      FirebaseFirestore.instance
          .collection('applications')
          .where('applicant_uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

  String recent_posts_note = '';
  String recommended_posts_note = '';

  List recent_posts = [];
  List recent_posts_photos = [];
  List recent_posts_uid = [];

  List recommended_posts = [];
  List recommended_posts_photos = [];
  List recommended_posts_uid = [];

  List user_majors = [];

  bool finish = false;

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
    if (recent_posts.isEmpty) {
      recent_posts_note = 'No recent posts found';
    }
    CollectionReference companies =
        FirebaseFirestore.instance.collection('companies');
    for (var i = 0; i < recent_posts_uid.length; i++) {
      await companies
          .doc(recent_posts[i]['uid'])
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          setState(() {
            recent_posts_photos.add(ds.data().toString().contains('photoUrl')
                ? ds.get('photoUrl')
                : '');
          });
        } else {
          print('Document does not exist on the database');
        }
      });
    }
  }

  Future getRecomendedPosts() async {
    // Get docs from collection reference
    CollectionReference user__breifcv_ref =
        FirebaseFirestore.instance.collection('briefcvs');
    user__breifcv_ref.doc(user!.uid).get().then((DocumentSnapshot ds) async {
      if (ds.exists) {
        if (ds.data().toString().contains('majors')) {
          final briefCVMap = ds.data() as Map<String, dynamic>;
          final briefCVList = briefCVMap['majors']!
              .map((e) => e.toString().toLowerCase())
              .toList();
          Query<Map<String, dynamic>> posts_ref =
              await FirebaseFirestore.instance
                  .collection("posts")
                  .where('active', isEqualTo: true)
                  .where('major', whereIn: briefCVList) //////////
                  .orderBy("timestamp", descending: true);
          QuerySnapshot querySnapshot = await posts_ref.get();

          // Get data from docs and convert map to List
          final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
          final allDataUid =
              querySnapshot.docs.map((doc) => doc.reference.id).toList();
          // print(allDataUid);
          setState(() {
            recommended_posts = allData;
            recommended_posts_uid = allDataUid;
          });

          if (allData.isEmpty) {
            setState(() {
              recommended_posts_note = 'No recommended posts found';
            });
          }
          CollectionReference companies =
              FirebaseFirestore.instance.collection('companies');
          for (var i = 0; i < recommended_posts_uid.length; i++) {
            await companies
                .doc(recommended_posts[i]['uid'])
                .get()
                .then((DocumentSnapshot ds) {
              // print(i);
              if (ds.exists) {
                setState(() {
                  recommended_posts_photos.add(
                      ds.data().toString().contains('photoUrl')
                          ? ds.get('photoUrl')
                          : '');
                });
              } else {
                print('Document does not exist on the database');
              }
            });
          }
        }
      } else {
        print('Document does not exist on the database');
      }
    });
    if (recommended_posts.isEmpty) {
      setState(() {
        recommended_posts_note = 'No recommended posts found';
      });
    }
    // setState(() {
    //   finish = true;
    // });
  }

  // Future getLogo() async {
  //   //TODO: Get image from the uid of getPosts
  //   setState(() {
  //     finish = true;
  //   });
  // }

  Future popup() async {
    userAppliedStream.listen((event) {
      event.docChanges.forEach((element) async {
        final doc = element.doc.data();
        final status = await doc!['status'];

        var title = '';
        var text = '';
        var desc = 'check your notifications for more information.';
        QuickAlertType type = QuickAlertType.custom;
        if (status != 'pending' &&
            (doc!['seen'] == null || doc!['seen'] == false)) {
          if (status == 'waiting') {
            print('re');
            title = 'Congratulations 👏 !';
            text =
                'Your applied job got accepted and waiting for you to accept the meeting.';
            QuickAlert.show(
                context: context,
                type: type,
                barrierDismissible: true,
                confirmBtnText: 'Ok',
                confirmBtnTextStyle: const TextStyle(color: canvasColor),
                confirmBtnColor: Colors.white,
                backgroundColor: canvasColor,
                customAsset: 'assets/images/noti_gif3.gif',
                widget: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    desc,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                title: title,
                titleColor: Colors.white,
                text: text,
                textColor: Colors.white);
          } else if (status == 'approved') {
            title = 'Congratulations 🤝 !';
            text = 'Your applied job got approved ✍️ !';
            type = QuickAlertType.success;
            QuickAlert.show(
                context: context,
                type: type,
                barrierDismissible: true,
                confirmBtnText: 'Ok',
                confirmBtnTextStyle: const TextStyle(color: canvasColor),
                confirmBtnColor: Colors.white,
                backgroundColor: canvasColor,
                widget: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    desc,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                title: title,
                titleColor: Colors.white,
                text: text,
                textColor: Colors.white);
          } else if (status == 'rejected') {
            title = 'Sorry 😢 !';
            text = 'Your applied job got rejected.';
            type = QuickAlertType.error;
            QuickAlert.show(
                context: context,
                type: type,
                barrierDismissible: true,
                confirmBtnText: 'Ok',
                confirmBtnTextStyle: const TextStyle(color: canvasColor),
                confirmBtnColor: Colors.white,
                backgroundColor: canvasColor,
                widget: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    desc,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                title: title,
                titleColor: Colors.white,
                text: text,
                textColor: Colors.white);
          }
          if (status == 'waiting' ||
              status == 'approved' ||
              status == 'rejected') {
            DocumentReference application_ref = FirebaseFirestore.instance
                .collection('applications')
                .doc(element.doc.reference.id);
            await application_ref.update({'seen': true});
          }
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      EasyLoading.show(status: 'loading...');
      user_provider!.getUserInfo();
      await getRecentPosts();
      await getRecomendedPosts();
      await popup();
      setState(() {
        finish = true;
      });
      EasyLoading.dismiss();
    });
    getToken();

    firebaseMessaging.requestPermission(
        alert: true, sound: true, badge: true, announcement: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? ios = message.notification?.apple;
    });

    super.initState();
  }

  void getToken() async {
    token = (await firebaseMessaging.getToken())!;
  }

  usr.User? user_provider;

  // Future getInfo() async {
  //   if (user_provider!.uid != null &&
  //       recent_posts.isNotEmpty &&
  //       recommended_posts.isNotEmpty) {
  //     return;
  //   }
  //   await user_provider!.getUserInfo();
  //   await getRecentPosts();
  //   await getRecomendedPosts();
  // }

  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    user_provider = Provider.of<usr.User>(context, listen: false);
    // return FutureBuilder(
    //     future: getInfo(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      backgroundColor: accentCanvasColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Welcome, ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: white),
                      ),
                      Text(
                        user_provider!.name ?? '...',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: primaryColor),
                      ),
                    ],
                  ),
                  const Text(
                    'apply now, and find your job!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: white),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    children: [
                      Text(
                        'Recent Jobs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: white),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecentJobs(
                                      recent_posts: recent_posts,
                                      recent_posts_uid: recent_posts_uid,
                                      recent_posts_photos: recent_posts_photos,
                                      name: 'Recent Jobs',
                                    )),
                          ).then((value) {
                            print('object');
                          });
                        },
                        child: Text(
                          'show more',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: white),
                        ),
                      ),
                    ],
                  ),
                ),
                recent_posts.isNotEmpty
                    ? !finish
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 120,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    CardLoading(
                                      curve: Curves.fastOutSlowIn,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      animationDurationTwo:
                                          const Duration(milliseconds: 1000),
                                      cardLoadingTheme: CardLoadingTheme(
                                          colorOne:
                                              canvasColor.withOpacity(0.5),
                                          colorTwo: accentCanvasColor
                                              .withOpacity(0.5)),
                                      height: 100,
                                      width: 240,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    SizedBox(width: 10),
                                    CardLoading(
                                      curve: Curves.fastOutSlowIn,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      animationDurationTwo:
                                          const Duration(milliseconds: 1000),
                                      cardLoadingTheme: CardLoadingTheme(
                                          colorOne:
                                              canvasColor.withOpacity(0.5),
                                          colorTwo: accentCanvasColor
                                              .withOpacity(0.5)),
                                      height: 100,
                                      width: 240,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                  ]),
                            ),
                          )
                        : SizedBox(
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
                                                company_uid: recent_posts[i]
                                                    ['uid'],
                                                post_uid: recent_posts_uid[i],
                                                post_image:
                                                    recent_posts_photos[i],
                                                job_title: recent_posts[i]
                                                    ['job_title'],
                                                descreption: recent_posts[i]
                                                    ['descreption'],
                                                yearsOfExperience:
                                                    recent_posts[i]
                                                        ['experience_years'],
                                                location: recent_posts[i]
                                                    ['city'],
                                                major: recent_posts[i]['major'],
                                                type: recent_posts[i]['type'],
                                                timestamp: recent_posts[i]
                                                    ['timestamp'],
                                              )),
                                    ).then((value) {
                                      print('object');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
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
                                                  finish &&
                                                          i <
                                                              recent_posts_photos
                                                                  .length
                                                      ? recent_posts_photos[i]
                                                      : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
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
                                                      recent_posts[i]
                                                          ['job_title'],
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                      recent_posts[i]
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
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '${recent_posts[i]['experience_years']} years of experience',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          // fontWeight: FontWeight,
                                                          color: white),
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
                                                          color: white),
                                                    ),
                                                    Text(
                                                      recent_posts[i]['major'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                            ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          recent_posts_note,
                          style: const TextStyle(color: primaryColor),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                  child: Row(
                    children: [
                      Text(
                        'Recommended Jobs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: white),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecentJobs(
                                      recent_posts: recommended_posts,
                                      recent_posts_uid: recommended_posts_uid,
                                      recent_posts_photos:
                                          recommended_posts_photos,
                                      name: 'Recommended Jobs',
                                    )),
                          ).then((value) {
                            print('object');
                          });
                        },
                        child: Text(
                          'show more',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: white),
                        ),
                      ),
                    ],
                  ),
                ),
                recommended_posts.isNotEmpty
                    ? !finish
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 120,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    CardLoading(
                                      curve: Curves.fastOutSlowIn,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      animationDurationTwo:
                                          const Duration(milliseconds: 1000),
                                      cardLoadingTheme: CardLoadingTheme(
                                          colorOne:
                                              canvasColor.withOpacity(0.5),
                                          colorTwo: accentCanvasColor
                                              .withOpacity(0.5)),
                                      height: 100,
                                      width: 240,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    SizedBox(width: 10),
                                    CardLoading(
                                      curve: Curves.fastOutSlowIn,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      animationDurationTwo:
                                          const Duration(milliseconds: 1000),
                                      cardLoadingTheme: CardLoadingTheme(
                                          colorOne:
                                              canvasColor.withOpacity(0.5),
                                          colorTwo: accentCanvasColor
                                              .withOpacity(0.5)),
                                      height: 100,
                                      width: 240,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                  ]),
                            ),
                          )
                        : SizedBox(
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
                                                company_uid:
                                                    recommended_posts[i]['uid'],
                                                post_uid:
                                                    recommended_posts_uid[i],
                                                post_image:
                                                    recommended_posts_photos[i],
                                                job_title: recommended_posts[i]
                                                    ['job_title'],
                                                descreption:
                                                    recommended_posts[i]
                                                        ['descreption'],
                                                yearsOfExperience:
                                                    recommended_posts[i]
                                                        ['experience_years'],
                                                location: recommended_posts[i]
                                                    ['city'],
                                                major: recommended_posts[i]
                                                    ['major'],
                                                type: recent_posts[i]['type'],
                                                timestamp: recent_posts[i]
                                                    ['timestamp'],
                                              )),
                                    ).then((value) {
                                      print('object');
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      width: 240,
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
                                                  finish &&
                                                          i <
                                                              recommended_posts_photos
                                                                  .length
                                                      ? recommended_posts_photos[
                                                          i]
                                                      : 'https://firebasestorage.googleapis.com/v0/b/careergy-3e171.appspot.com/o/photos%2FCareergy.png?alt=media&token=d5d0a2b7-e143-4644-970d-c63fc573a5ba',
                                                  // scale: 1,
                                                  // fit: BoxFit.fitWidth,
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
                                                          color: white),
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
                                                          color: white),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '${recommended_posts[i]['experience_years']} years of experience',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          // fontWeight: FontWeight,
                                                          color: white),
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
                                                          color: white),
                                                    ),
                                                    Text(
                                                      recommended_posts[i]
                                                          ['major'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                            ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: 120,
                          child: Text(
                            recommended_posts_note,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete your profile !',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      finish
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.text_snippet_rounded,
                                      color: user_provider!.briefcv == null
                                          ? Colors.grey
                                          : primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add a breif CV to your profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle_sharp,
                                      color: user_provider!.photoUrl == null
                                          ? Colors.grey
                                          : primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add a new avatar to your profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.article_rounded,
                                      color: user_provider!.bio == ''
                                          ? Colors.grey
                                          : primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add Bio to your profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: user_provider!.birthdate == ''
                                          ? Colors.grey
                                          : primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add your birthdate to your profile',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            )
                          : Text('')
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

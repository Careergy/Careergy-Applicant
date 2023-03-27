// import 'dart:html';

import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/screens/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference briefcvs =
      FirebaseFirestore.instance.collection('briefcvs');
  String name = '';
  String email = '';
  String phone = '';
  String photo = '';
  String bio = '';
  String birthdate = '';
  String major = '';
  bool breifcv_exists = false;
  List<dynamic> intrests = [''];
  List<dynamic> major_skills = [''];
  List<dynamic> soft_skills = [''];
  List<dynamic> other_skills = [''];
  List<dynamic> job_title = [''];
  String location = '';

  void getUserInfo(String uid) {
    users.doc(uid).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        // print('Document data: ${ds.data()}');
        setState(() {
          name = ds.data().toString().contains('name') ? ds.get('name') : '';
          email = ds.data().toString().contains('email') ? ds.get('email') : '';
          phone = ds.data().toString().contains('phone') ? ds.get('phone') : '';
          photo = ds.data().toString().contains('photo') ? ds.get('photo') : '';
          bio = ds.data().toString().contains('bio') ? ds.get('bio') : '';
          birthdate = ds.data().toString().contains('birthdate')
              ? ds.get('birthdate')
              : '';
          major = ds.data().toString().contains('major') ? ds.get('major') : '';
        });
      } else {
        print('Document does not exist on the database');
      }
    });

    briefcvs.doc(uid).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
        Map<String, dynamic> data = ds!.data() as Map<String, dynamic>;
        print('Document data: ${ds.data()}');
        print(data['job_title']);
        breifcv_exists = true;
        setState(() {
          print('hi');
          intrests = ds.data().toString().contains('intrests')
              ? data['intrests']
              : [''];
          major_skills = ds.data().toString().contains('major_skills')
              ? data['major_skills']
              : [''];
          soft_skills = ds.data().toString().contains('soft_skills')
              ? data['soft_skills']
              : [''];
          other_skills = ds.data().toString().contains('other_skills')
              ? data['other_skills']
              : [''];
          job_title = ds.data().toString().contains('soft_skills')
              ? data['job_title']
              : [''];
          location = ds.data().toString().contains('location')
              ? ds.get('location')
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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // do something
      getUserInfo(user!.uid);
      print("Build Completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    print(job_title);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: Image(
                          image: AssetImage(
                              'assets/images/avatarPlaceholder.png')),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email != '' ? email : 'empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color:
                                    email != '' ? Colors.black : Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            phone != '' ? phone : 'empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color:
                                    phone != '' ? Colors.black : Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Bio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Text(
                        bio != '' ? bio : 'empty',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: bio != '' ? Colors.black : Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Major',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            major != '' ? major : 'empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color:
                                    major != '' ? Colors.black : Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Birthdate',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            birthdate != '' ? birthdate : 'empty',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: birthdate != ''
                                    ? Colors.black
                                    : Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Brief CV',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            breifcv_exists
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // job_title.isNotEmpty ?
                                      Text(
                                        'Job title: ${job_title[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: birthdate != ''
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      Text(
                                        'Intrests: ${intrests[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: birthdate != ''
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      Text(
                                        'Major skills: ${major_skills[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: birthdate != ''
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      Text(
                                        'Soft skills: ${soft_skills[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: birthdate != ''
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                      Text(
                                        'Other skills: ${other_skills[0]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: birthdate != ''
                                                ? Colors.black
                                                : Colors.grey),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: TextButton(
                                        onPressed: () {
                                          print('brief cv button');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BriefCV()));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.blue,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          // color: Colors.blue,
                                          child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 100),
                                              child: Text(
                                                'Add',
                                                // style: TextStyle(color: Colors.white),
                                              )),
                                        )),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print('pressed');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                      name: name,
                      email: email,
                      phone: phone,
                      bio: bio,
                      major: major,
                      birthdate: birthdate,
                      photo: photo,
                    )),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}

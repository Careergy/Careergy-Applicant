import 'dart:io';
import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/screens/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  String imageUrl = '';

  Future<void> getUserInfo(String uid) async {
    EasyLoading.show(status: 'loading...');
    imageUrl = await FirebaseStorage.instance
        .ref('photos/${user!.uid}')
        .getDownloadURL();
    users.doc(uid).get().then((DocumentSnapshot ds) {
      if (ds.exists) {
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
        breifcv_exists = true;
        setState(() {
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
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserInfo(user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(job_title);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageUrl != ''
                          ? NetworkImage(imageUrl!)
                          : const AssetImage(
                                  'assets/images/avatarPlaceholder.png')
                              as ImageProvider),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            breifcv_exists
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Job title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          job_title[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: job_title[0] != 'none'
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Intrests',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          intrests[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: intrests[0] != 'none'
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Major skills',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          major_skills[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: major_skills[0] != 'none'
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Soft skills',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          soft_skills[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: soft_skills[0] != 'none'
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Other skills',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          other_skills[0] != ''
                                              ? other_skills[0]
                                              : 'none',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: other_skills[0] != ''
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            Center(
                              child: TextButton(
                                  onPressed: () {
                                    print('brief cv button');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BriefCV())).then((value) {
                                      getUserInfo(user!.uid);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    // color: Colors.blue,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 100),
                                        child: breifcv_exists
                                            ? const Text(
                                                'Update',
                                              )
                                            : const Text(
                                                'Add',
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
                      photo: imageUrl,
                    )),
          ).then((value) {
            getUserInfo(user!.uid);
          });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

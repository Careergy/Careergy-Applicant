import 'dart:io';

import 'package:careergy_mobile/models/user.dart' as usr;
import 'package:careergy_mobile/screens/brief_cv.dart';
import 'package:careergy_mobile/screens/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
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
  late usr.User user;

  Future refresh() async {
    if (user.uid != null) {
      return;
    }
    await user.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<usr.User>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Profile'),
      body: FutureBuilder(
        future: refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          child: user.photoUrl == null
                              ? CircleAvatar(
                                  radius: 50,
                                  child: ClipOval(child: user.photo))
                              : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100.0)),
                                  child: Image.network(
                                    user.photoUrl ?? 'https://www.google.com/',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      );
                                    },
                                  ),
                                )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name ?? 'empty',
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
                                  user.email != ''
                                      ? user.email ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: user.email != ''
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
                                  user.phone == ''
                                      ? 'empty'
                                      : user.phone ?? 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color:
                                          user.phone != null && user.phone != ''
                                              ? Colors.black
                                              : Colors.grey),
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
                                  user.bio != ''
                                      ? user.bio ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: user.bio != ''
                                          ? Colors.black
                                          : Colors.grey),
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
                                  user.birthdate != ''
                                      ? user.birthdate ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: user.birthdate != ''
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
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BriefCV(),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
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
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 100),
                                          child: user.breifcvExists
                                              ? const Text(
                                                  'View/Edit',
                                                )
                                              : const Text(
                                                  'Add',
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
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
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user)));
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

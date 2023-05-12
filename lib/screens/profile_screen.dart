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

  briefCVDialog() {
    //alert dialog for brief cv
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Brief CV'),
          content: const Text(
              'Let companies know you better!. This will be visible to the employers.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<usr.User>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Profile'),
      backgroundColor: accentCanvasColor,
      body: FutureBuilder(
        future: refresh(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              user.name ?? 'empty',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: white),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 30),
                              child: user.photoUrl == null
                                  ? CircleAvatar(
                                      radius: 70,
                                      child: ClipOval(child: user.photo))
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100.0)),
                                      child: Image.network(
                                        user.photoUrl ??
                                            'https://www.google.com/',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fitWidth,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
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
                                    ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.email, color: primaryColor),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  user.email != ''
                                      ? user.email ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: user.email != ''
                                          ? Colors.white70
                                          : Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            divider,
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.phone, color: primaryColor),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  user.phone == ''
                                      ? 'empty'
                                      : user.phone ?? 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color:
                                          user.phone != null && user.phone != ''
                                              ? Colors.white70
                                              : Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            divider,
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bio',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  user.bio != ''
                                      ? user.bio ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: user.bio != ''
                                          ? Colors.white70
                                          : Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            divider,
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    color: primaryColor),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  user.birthdate != ''
                                      ? user.birthdate ?? 'empty'
                                      : 'empty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: user.birthdate != ''
                                          ? Colors.white70
                                          : Colors.grey),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            divider,
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Brief CV',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () => briefCVDialog(),
                                    child: Icon(Icons.info,
                                        color: Colors.orangeAccent)),
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
                                              color: primaryColor,
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
                                                  style: TextStyle(
                                                      color: primaryColor),
                                                )
                                              : const Text(
                                                  'Add',
                                                  style: TextStyle(
                                                      color: primaryColor),
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
        backgroundColor: primaryColor,
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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart' as usr;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  // final String name;
  // final String email;
  // final String phone;
  // final String photo;
  // final String bio;
  // final String birthdate;
  // final String major;

  final usr.User user;

  const EditProfileScreen({super.key, required this.user});

  // const EditProfileScreen(
  //     {super.key,
  //     required this.name,
  //     required this.email,
  //     required this.phone,
  //     required this.photo,
  //     required this.bio,
  //     required this.birthdate,
  //     required this.major});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user_ = FirebaseAuth.instance.currentUser;
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  final photosReference = FirebaseStorage.instance.ref('photos/');
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController bio_controller = TextEditingController();
  TextEditingController major_controller = TextEditingController();
  TextEditingController birthdate_controller = TextEditingController();
  String imageUrl = '';
  // TextEditingController photo_controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    // name_controller.text = widget.name;
    // email_controller.text = widget.email;
    // phone_controller.text = widget.phone;
    // bio_controller.text = widget.bio;
    // major_controller.text = widget.major;
    // birthdate_controller.text = widget.birthdate;
    // imageUrl = widget.photo;
  }

  final ImagePicker _picker = ImagePicker();

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<usr.User>(context);
    name_controller.text = widget.user.name ?? '';
    email_controller.text = widget.user.email ?? '';
    phone_controller.text = widget.user.phone ?? '';
    bio_controller.text = widget.user.bio ?? '';
    // major_controller.text = user.major;
    birthdate_controller.text = widget.user.birthdate ?? '';
    imageUrl = user.photoUrl ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: canvasColor,
      ),
      body: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: image != null
                                ? AssetImage(image!.path)
                                : imageUrl != ''
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage(
                                            'assets/images/avatarPlaceholder.png')
                                        as ImageProvider,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                // radius: 20.0,
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  iconSize: 20.0,
                                  color: Colors.blue,
                                  onPressed: () {
                                    pickImage();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue),
                                )
                              ],
                            ),
                            TextField(
                              controller: name_controller,
                              decoration: const InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 30)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                            TextField(
                              controller: email_controller,
                              decoration: const InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 30)),
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
                            TextField(
                              controller: phone_controller,
                              decoration: const InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 30)),
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
                            TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: bio_controller,
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
                            TextField(
                              controller: birthdate_controller,
                              decoration: const InputDecoration(
                                  constraints: BoxConstraints(maxHeight: 30)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          EasyLoading.show(status: 'Saving...');
          if (image != null) {
            await photosReference.child(user_!.uid).putFile(image!);
            await FirebaseStorage.instance
                .ref('photos/${user.uid}')
                .getDownloadURL()
                .then((value) => user.photoUrl = value)
                .onError(
              (error, stackTrace) {
                // photoUrl = null;
                return 'error';
              },
            );
          }

          setState(() {
            isLoading = true;
          });

          user.name = name_controller.text;
          user.email = email_controller.text;
          user.phone = phone_controller.text;
          user.bio = bio_controller.text;
          user.birthdate = birthdate_controller.text;
          // user.photo = image!;
          await user.setUserInfo();
          await user.getUserInfo();
          EasyLoading.dismiss();
          setState(() {
            isLoading = false;
            Navigator.pop(context);
          });
        },
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save'),
      ),
    );
  }
}

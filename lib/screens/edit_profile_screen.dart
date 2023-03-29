import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String bio;
  final String birthdate;
  final String major;

  const EditProfileScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.photo,
      required this.bio,
      required this.birthdate,
      required this.major});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController name_controller = new TextEditingController();
  TextEditingController email_controller = new TextEditingController();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController bio_controller = new TextEditingController();
  TextEditingController major_controller = new TextEditingController();
  TextEditingController birthdate_controller = new TextEditingController();
  TextEditingController photo_controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    name_controller.text = widget.name;
    email_controller.text = widget.email;
    phone_controller.text = widget.phone;
    bio_controller.text = widget.bio;
    major_controller.text = widget.major;
    birthdate_controller.text = widget.birthdate;
    photo_controller.text = widget.photo;
  }

  final ImagePicker _picker = ImagePicker();

  File? image;
  Future pickImage() async {
    try {
      print('clicked');
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: kBlue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          AssetImage('assets/images/avatarPlaceholder.png'),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          // radius: 20.0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: 20.0,
                            color: Colors.blue,
                            onPressed: () {
                              print('photo');
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
                        // obscureText: true,
                        controller: name_controller,
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            // labelText: '_controller',
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
                        // obscureText: true,
                        controller: email_controller,
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            // labelText: '_controller',
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
                        // obscureText: true,
                        controller: phone_controller,
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            // labelText: '_controller',
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
                        // obscureText: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: bio_controller,
                        // decoration: const InputDecoration(
                        //     // border: OutlineInputBorder(),
                        //     // labelText: '_controller',
                        //     constraints: BoxConstraints(maxHeight: 30)),
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
                      TextField(
                        // obscureText: true,
                        controller: major_controller,
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            // labelText: '_controller',
                            constraints: BoxConstraints(maxHeight: 30)),
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
                        // obscureText: true,
                        controller: birthdate_controller,
                        decoration: const InputDecoration(
                            // border: OutlineInputBorder(),
                            // labelText: '_controller',
                            constraints: BoxConstraints(maxHeight: 30)),
                      ),
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
          users
              .doc(user!.uid)
              .update({
                'name': name_controller.text,
                'email': email_controller.text,
                'phone': phone_controller.text,
                'bio': bio_controller.text,
                'major': major_controller.text,
                'birthdate': birthdate_controller.text,
                'photo': photo_controller.text,
              })
              .then((value) => {
                    print("User Updated"),
                    Navigator.pop(context),
                  })
              .catchError((error) => print("Failed to update user: $error"));
          ;
          // Navigator.pop(context);
        },
        child: const Text('Save'),
      ),
    );
  }
}
// class EditProfileScreen extends StatelessWidget {
//   const EditProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Route'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//           },
//           child: const Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

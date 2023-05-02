import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User with ChangeNotifier {
  late String? uid;
  late String? name;
  late String? email;
  late String? phone;
  late String? photoUrl;
  late String? birthdate;
  Image photo =
      const Image(image: AssetImage('assets/images/avatarPlaceholder.png'));
  late String? bio;
  Map<String, List?>? briefcv;

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final fs = FirebaseStorage.instance.ref();

  User() {
    getUserInfo();
  }

  bool get breifcvExists {
    return briefcv != null;
  }

  Future getUserInfo({String? uid}) async {
    uid ??= auth.currentUser?.uid;
    if (uid == null) {
      return;
    }
    final ref = db.collection('users').doc(uid);
    photoUrl =
        await FirebaseStorage.instance.ref('photos/$uid').getDownloadURL();
    await ref.get().then(
      (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        this.uid = uid!;
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        // photoUrl = data['photoUrl'] ?? '';
        birthdate = data['birthdate'] ?? '';
        bio = data['bio'] ?? '';
      },
      onError: (e) => print("Error getting document: $e"),
    );
    await getBriefCV();
    // await getAvatar();
    notifyListeners();
  }

  Future getBriefCV() async {
    final ref = db.collection('briefcvs').doc(uid);
    await ref.get().then((value) {
      if (value.exists) {
        final data = value.data();
        final jobTitles =
            (data!['job_title'] as List).map((e) => e as String).toList();
        final majorSkills =
            (data['major_skills'] as List).map((e) => e as String).toList();
        final softSkills =
            (data['soft_skills'] as List).map((e) => e as String).toList();
        final intrests =
            (data['intrests'] as List).map((e) => e as String).toList();
        final otherSkills =
            (data['other_skills'] as List).map((e) => e as String).toList();
        final locations = (data['prefered_locations'] as List)
            .map((e) => e as String)
            .toList();
        briefcv = {
          'job_title': jobTitles,
          'major_skills': majorSkills,
          'soft_skills': softSkills,
          'intrests': intrests,
          'other_skills': otherSkills,
          'prefered_locations': locations,
        };
        return;
      }
      briefcv = null;
    });
  }

  Future setBriefCV() async {
    final ref = db.collection('briefcvs').doc(uid);
    await ref.set(briefcv!).onError((error, stackTrace) => print(error));
  }

  Future setUserInfo() async {
    final ref = db.collection('users').doc(uid);
    await ref.update({
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'birthdate': birthdate
    });
    notifyListeners();
  }

  Future getAvatar() async {
    final imagesRef = fs.child("photos/$uid");
    try {
      print(imagesRef.fullPath);
      const oneMegabyte = 1024 * 512;
      final Uint8List? data = await imagesRef.getData(oneMegabyte);
      // // Data for "images/island.jpg" is returned, use this as needed.
      photo = Image.memory(data!);
    } on FirebaseException catch (e) {
      // Handle any errors.
      print('Avatar $e');
    }
  }

  void discard() {
    uid = null;
    name = null;
    email = null;
    phone = null;
    photoUrl = null;
    bio = null;
    birthdate = null;
    briefcv = null;
    notifyListeners();
    dispose();
  }
}

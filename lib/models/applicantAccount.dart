import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class ApplicantAccount {
  late final String uid;
  String fname;
  String lname;
  late final String email;
  String? phone;
  Image? photo;
  String? token;
  late final DateTime? accountCreationTime;
  DateTime? birthDate;
  String? nationality;
  String? gender;

  String? major;
  List? majorSkills;
  List? softSkills;
  String? intrest;

  ApplicantAccount(
      {required this.uid,
      required this.fname,
      required this.lname,
      required this.email,
      this.phone,
      this.photo,
      this.token,
      this.accountCreationTime,
      this.birthDate,
      this.nationality,
      this.gender,
      this.major,
      this.majorSkills,
      this.softSkills,
      this.intrest});

  void editProfile(fname, lname, phone, photo, birthDate_year, birthDate_month,
      birthDate_day, nationality, gender) {
    this.fname = fname;
    this.lname = lname;
    this.phone = phone;
    this.birthDate =
        DateTime.utc(birthDate_year, birthDate_month, birthDate_day);
    this.nationality = nationality;
    this.gender = gender;
  }

  void makeBriefCV(major, majorSkills, softSkills, intrest) {
    this.major = major;
    this.majorSkills = majorSkills;
    this.softSkills = softSkills;
    this.intrest = intrest;
  }
}

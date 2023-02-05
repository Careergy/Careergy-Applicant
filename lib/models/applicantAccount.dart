import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class ApplicantAccount {
  late final String uid;
  late final String fname;
  late final String lname;
  late final String email;
  late final String? phone;
  late final Image? photo;
  late final String? token;
  late final DateTime? accountCreationTime;
  late final DateTime? birthDate;
  late final String? nationality;
  late final String? gender;

  late final String? major;
  late final List? majorSkills;
  late final List? softSkills;
  late final String? intrest;

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

  void editProfile(
      firstName, lastName, phone, photo, birthDate, nationality, gender) {
    this.fname = firstName;
    this.lname = lastName;
    this.phone = phone;
    this.birthDate = birthDate;
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

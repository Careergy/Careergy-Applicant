import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart' as user;

class ApplicantAccount extends user.User {
  DateTime? birthDate;
  String? nationality;
  String? gender;

  String? major;
  List? majorSkills;
  List? softSkills;
  String? intrest;

  ApplicantAccount(
      {required super.uid,
      required super.fname,
      required super.lname,
      required super.email,
      super.phone,
      super.photo,
      this.birthDate,
      this.nationality,
      this.gender,
      this.major,
      this.majorSkills,
      this.softSkills,
      this.intrest});

  void editProfile(fname, lname, int phone, Image photo, birthDate_year,
      birthDate_month, birthDate_day, nationality, gender) {
    this.fname = fname;
    this.lname = lname;
    this.phone = phone;
    this.photo = photo;
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

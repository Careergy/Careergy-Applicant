import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart' as user;

class ApplicantAccount extends user.User {
  DateTime? birthDate;
  String? nationality;
  String? gender;

  List<String>? major;
  List<String>? majorSkills;
  List<String>? softSkills;
  String? intrest;
  int? graduationYear;
  int? yearsOfExperience;
  List<String>? degrees;

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
      this.intrest,
      this.graduationYear,
      this.yearsOfExperience,
      this.degrees});

  // get all profile info then update the changes
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

  // this method for making or editing Brief CV.
  //for edit: use getBriefCV() info then update changes
  void makeBriefCV(major, majorSkills, softSkills, intrest, graduationYear,
      yearsOfExperience, degrees) {
    this.major = major;
    this.majorSkills = majorSkills;
    this.softSkills = softSkills;
    this.intrest = intrest;
    this.graduationYear = graduationYear;
    this.yearsOfExperience = yearsOfExperience;
    this.degrees = degrees;
  }

  // get Brief CV info from database
  Future getBriefCV() async {
    return [];
  }
}

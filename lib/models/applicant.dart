import 'package:careergy_mobile/models/applicantAccount.dart';
import 'package:careergy_mobile/models/attachment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Applicant {
  late final String applicationID;
  int numOfApplications = 0;

  // when send button is clicked , this method will be triggered
  void sendApplication(userID, cv, attachments, briefCV, jobID) {
    // send application to the company
    numOfApplications++;
  }

  // when cancel button is clicked , this method will be triggered
  void cancelApplication(jobID) {
    numOfApplications--;
  }

  // get application by application ID
  Future getApplicationByID(applicationID) async {}

  // get all applications from database
  Future getAllApplications() async {
    if (numOfApplications > 0) {
      // list all applications
      return [];
    } else {
      return "you have 0 applications";
    }
  }

// when search bar is clicked , this method will be triggered
  Future getSearchHistory() async {
    return [];
  }

  // while user is typing in the search bar , this method will be triggered
  Future searchForCompany() async {
    // if search input matching a company or a job from database then
    // get info and show on the screen
    // else show 0 result
    return [];
  }

  // get company information from the database
  Future getCompanyInfo(companyID) async {
    return [];
  }
}

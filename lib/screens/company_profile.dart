import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/screens/company_about_profile.dart';
import 'package:careergy_mobile/screens/company_jobs_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'apply_for_company_Screen.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Profile'),
        backgroundColor: kBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Here will be a company profile'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CompanyAboutProfile()));
              },
              child: const Text('About Us'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CompanyJobsProfile()));
              },
              child: const Text('Jobs'),
            )
          ],
        ),
      ),
    );
  }
}

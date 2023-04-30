import 'package:careergy_mobile/screens/apply_for_company-scnd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../constants.dart';

class ApplyForCompanyScreen extends StatefulWidget {
  final String company_uid;
  final String post_uid;
  final String post_image;
  final String job_title;
  final String descreption;
  final String yearsOfExperience;
  final String location;

  const ApplyForCompanyScreen(
      {super.key,
      required this.company_uid,
      required this.post_uid,
      required this.post_image,
      required this.job_title,
      required this.descreption,
      required this.yearsOfExperience,
      required this.location});

  @override
  State<ApplyForCompanyScreen> createState() => _ApplyForCompanyScreenState();
}

class _ApplyForCompanyScreenState extends State<ApplyForCompanyScreen> {
  String company_uid = '';
  String post_uid = '';
  String post_image = '';
  String job_title = '';
  String descreption = '';
  String yearsOfExperience = '';
  String location = '';

  @override
  void initState() {
    super.initState();

    company_uid = widget.company_uid;
    post_uid = widget.post_uid;
    post_image = widget.post_image;
    job_title = widget.job_title;
    descreption = widget.descreption;
    yearsOfExperience = widget.yearsOfExperience;
    location = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: const Text('Job Application'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Image.network('https://picsum.photos/200/300'),
                  ),
                  Column(
                    children: [
                      Text(
                        'Title: $job_title',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Years of experience: $yearsOfExperience',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              Divider(),
              Text('Description:'),
              Container(
                height: 200,
                child: SingleChildScrollView(
                  child: Text(descreption),
                ),
              ),
              const Text(
                'CV',
                style: TextStyle(
                    color: kBlue, fontSize: 26.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

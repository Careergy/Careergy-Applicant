import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CompanyAboutProfile extends StatefulWidget {
  const CompanyAboutProfile({super.key});

  @override
  State<CompanyAboutProfile> createState() => _CompanyAboutProfileState();
}

class _CompanyAboutProfileState extends State<CompanyAboutProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('About Us'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Text(
                'here will be company information, website, contact information and place',
              )
            ])));
  }
}

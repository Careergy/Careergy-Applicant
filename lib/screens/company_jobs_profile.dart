import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CompanyJobsProfile extends StatefulWidget {
  const CompanyJobsProfile({super.key});

  @override
  State<CompanyJobsProfile> createState() => _CompanyJobsProfileState();
}

class _CompanyJobsProfileState extends State<CompanyJobsProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Jobs'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Text(
                'here will be a list of jobs opportunity',
              )
            ])));
  }
}

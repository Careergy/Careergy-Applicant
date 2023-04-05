import 'package:careergy_mobile/screens/apply_for_company-scnd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ApplyForCompanyScreen extends StatefulWidget {
  const ApplyForCompanyScreen({super.key});

  @override
  State<ApplyForCompanyScreen> createState() => _ApplyForCompanyScreenState();
}

class _ApplyForCompanyScreenState extends State<ApplyForCompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Job Offer'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Company information and job desciption here',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ApplyForCompanyScnd()));
                  },
                  child: const Text('Apply'),
                )
              ],
            ),
          ),
        ));
  }
}

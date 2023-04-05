import 'package:careergy_mobile/screens/timeslots_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ApplyForCompanyScnd extends StatefulWidget {
  const ApplyForCompanyScnd({super.key});

  @override
  State<ApplyForCompanyScnd> createState() => _ApplyForCompanyScndState();
}

class _ApplyForCompanyScndState extends State<ApplyForCompanyScnd> {
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
                  'Select CV and attachment',
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimeslotScreen()));
                  },
                  child: const Text('Continue'),
                )
              ],
            ),
          ),
        ));
  }
}

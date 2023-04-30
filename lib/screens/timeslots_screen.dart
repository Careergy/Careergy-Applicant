import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TimeslotScreen extends StatefulWidget {
  const TimeslotScreen({super.key});

  @override
  State<TimeslotScreen> createState() => _TimeslotScreenState();
}

class _TimeslotScreenState extends State<TimeslotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlue,
          title: const Text('Timeslots'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const Text(
                'here will be table to select timeslot',
              )
            ])));
  }
}

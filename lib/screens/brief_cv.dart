import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/custom_textfieldform.dart';

class BriefCV extends StatefulWidget {
  const BriefCV({super.key});

  @override
  State<BriefCV> createState() => _BriefCVState();
}

class _BriefCVState extends State<BriefCV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: const Text('Brief CV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                label: 'Name',
                hint: 'Enter your name',
                onChanged: (value) {},
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

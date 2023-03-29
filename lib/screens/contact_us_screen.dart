import 'package:careergy_mobile/widgets/custom_textfieldform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../constants.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlue,
        title: Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CustomTextField(
              label: 'Title',
              hint: 'hint',
              onChanged: (v) {
                print(v);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the Title';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            CustomTextField(
              contentPadding: const EdgeInsets.symmetric(vertical: 200),
              label: 'Message',
              hint: 'Enter the message',
              onChanged: (v) {
                print(v);
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the message';
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }
}

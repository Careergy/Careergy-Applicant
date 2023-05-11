import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ContactCompany extends StatefulWidget {
  const ContactCompany({super.key});

  @override
  State<ContactCompany> createState() => _ContactCompanyState();
}

class _ContactCompanyState extends State<ContactCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: Text('Contact Company'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contact Company Screen'),
            Text(
                'Here will be a contact company form inside the company profile')
          ],
        ),
      ),
    );
    ;
  }
}

import 'package:careergy_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
        title: Text('Brief CV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Brief CV Screen'),
            Text('Here will be a form to fill the brief cv')
          ],
        ),
      ),
    );
  }
}

import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';

class AppliedScreen extends StatefulWidget {
  const AppliedScreen({super.key});

  @override
  State<AppliedScreen> createState() => _AppliedScreenState();
}

class _AppliedScreenState extends State<AppliedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: const CustomAppBar(title: 'Applications'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Applied Screen',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

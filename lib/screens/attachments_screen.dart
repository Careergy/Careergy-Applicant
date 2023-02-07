import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_appbar.dart';

class AttatchmentsScreen extends StatefulWidget {
  const AttatchmentsScreen({super.key});

  @override
  State<AttatchmentsScreen> createState() => _AttatchmentsScreenState();
}

class _AttatchmentsScreenState extends State<AttatchmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(title: 'Attachments'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Attachments Screen',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

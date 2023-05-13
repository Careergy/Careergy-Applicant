import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:careergy_mobile/constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: canvasColor,
        title: const Text('Contact Us'),
      ),
      backgroundColor: accentCanvasColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Text(
              'Careergy is a platform for companies to post new jobs and for people to apply for them with ease.\nDeveloped as Software Engineering senior project in King Fahad University of Petroleum and Minerals in Spring semester (2022/2023).',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

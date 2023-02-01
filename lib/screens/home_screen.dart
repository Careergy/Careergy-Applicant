import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ElevatedButton(onPressed: null, child: Text('Log out')),
      );
  }
}
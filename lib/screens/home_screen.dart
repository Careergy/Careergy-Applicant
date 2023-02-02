import 'package:careergy_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Center(
      child: Column(
        children: [
          Text(auth.auth.currentUser!.displayName?? ''),
          Text(auth.auth.currentUser!.email?? ''),
          ElevatedButton(onPressed: auth.logout , child: const Text('Logout'))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      );
  }
}
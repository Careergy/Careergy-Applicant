import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/providers/auth_provider.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
// import 'package:riverpod/riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    // final authRef = ref.watch(auth);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Home Screen',
              ),
              ElevatedButton(
                onPressed: () {
                  auth.logout();
                },
                child: const Text('log out'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

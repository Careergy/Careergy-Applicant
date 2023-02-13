import 'package:careergy_mobile/constants.dart';
import 'package:careergy_mobile/providers/auth_provider.dart';
import 'package:careergy_mobile/widgets/custom_appbar.dart';
import 'package:careergy_mobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: const CustomAppBar(
        title: 'Home',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Home Screen',
            ),
          ],
        ),
      ),
    );
  }
}

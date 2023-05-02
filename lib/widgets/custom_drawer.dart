import 'package:careergy_mobile/models/user.dart' as usr;
import 'package:careergy_mobile/providers/auth_provider.dart';
import 'package:careergy_mobile/screens/contact_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<usr.User>(context);
    return Drawer(
      backgroundColor: kBlue,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: kBlue,
            ),
            child: Image.asset(
              'assets/images/Careergy.png',
              // scale: 1,
              // fit: BoxFit.contain,
            ),
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: const Text(
              'About us',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.contact_support_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Contact us',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsScreen()));
            },
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onTap: () async {
              await AuthProvider().logout();
              user.discard();
            },
          ),
        ],
      ),
    );
  }
}

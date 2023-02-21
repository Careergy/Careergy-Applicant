import 'package:careergy_mobile/screens/contact_us_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBlue,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kBlue,
            ),
            child: Text(
              'Careergy',
              style: TextStyle(color: Colors.white),
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
                  Icons.message,
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
        ],
      ),
    );
  }
}

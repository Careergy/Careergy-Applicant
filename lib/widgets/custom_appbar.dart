import 'package:careergy_mobile/screens/nav_bar.dart';
import 'package:careergy_mobile/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
              print('noti');
            },
            child: const Icon(
              Icons.notifications,
              size: 26.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: true,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: canvasColor,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

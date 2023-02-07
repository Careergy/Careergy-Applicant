import 'package:careergy_mobile/screens/applied_screen.dart';
import 'package:careergy_mobile/screens/attachments_screen.dart';
import 'package:careergy_mobile/screens/auth/auth_screen.dart';
import 'package:careergy_mobile/screens/home_screen.dart';
import 'package:careergy_mobile/screens/profile_screen.dart';
import 'package:careergy_mobile/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:careergy_mobile/constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int navBarIndex = 0;
  final screens = [
    const HomeScreen(),
    const SearchScreen(),
    const AttatchmentsScreen(),
    const AppliedScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: CustomDrawer(),
      body: IndexedStack(
        index: navBarIndex,
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: kBlue,
        ),
        child: BottomNavigationBar(
          currentIndex: navBarIndex,
          onTap: (int navBarIndex) {
            setState(() {
              this.navBarIndex = navBarIndex;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_file),
              label: 'Attachments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Applied',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14, color: Colors.blue),
        ),
      ),
    );
  }
}

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: kBlue,
//       child: ListView(
//         // Important: Remove any padding from the ListView.
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(
//               color: kBlue,
//             ),
//             child: Text(
//               'Careergy',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           ListTile(
//             title: const Text(
//               'Settings',
//               style: TextStyle(color: Colors.white),
//             ),
//             onTap: () {
//               // Update the state of the app.
//               // ...
//             },
//           ),
//           ListTile(
//             title: const Text(
//               'About us',
//               style: TextStyle(color: Colors.white),
//             ),
//             onTap: () {
//               // Update the state of the app.
//               // ...
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

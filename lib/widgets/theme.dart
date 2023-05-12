import 'dart:isolate';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:careergy_mobile/screens/applied_screen.dart';
import 'package:careergy_mobile/screens/attachments_screen.dart';
import 'package:careergy_mobile/screens/auth/auth_screen.dart';
import 'package:careergy_mobile/screens/home_screen.dart';
import 'package:careergy_mobile/screens/notifications_screen.dart';
import 'package:careergy_mobile/screens/profile_screen.dart';
import 'package:careergy_mobile/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:careergy_mobile/constants.dart';

class CustomThemeMode extends StatefulWidget {
  CustomThemeMode({
    super.key,
    this.isDark,
    required this.child,
    required this.themeMode,
  });

  @override
  State<CustomThemeMode> createState() => _CustomThemeModeState();
  bool? isDark;
  Widget? child;
  AdaptiveThemeMode? themeMode;
}

class _CustomThemeModeState extends State<CustomThemeMode> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: this.widget.themeMode!,
      light: ThemeData(
        brightness: Brightness.light,
        canvasColor: white,
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: primaryColor,
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: white,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        canvasColor: canvasColor,
        textTheme: TextTheme(
          bodySmall: TextStyle(color: white),
          bodyMedium: TextStyle(color: white),
          bodyLarge: TextStyle(color: white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvasColor,
          iconTheme: IconThemeData(color: white),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: canvasColor,
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: accentCanvasColor,
      ),
      builder: (theme, darkTheme) => MaterialApp(
        home: this.widget.child!,
        theme: theme,
        darkTheme: darkTheme,
      ),
    );
  }

  changeThemeMode() {
    this.widget.isDark!
        ? AdaptiveTheme.of(context).setLight()
        : AdaptiveTheme.of(context).setDark();

    setState(() {
      this.widget.isDark = !this.widget.isDark!;
    });
  }
}

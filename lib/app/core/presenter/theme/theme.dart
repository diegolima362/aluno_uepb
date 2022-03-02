import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // const bg = Color(0xffffffff);
    const bg = Color(0xffffffff);
    // const cardColor = Color(0xffeeeeee);
    const cardColor = Color(0xffffffff);

    const primary = Color(0xffff9500);
    const secondary = Color(0xff007aff);

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light().copyWith(
        primary: primary,
        secondary: secondary,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: Colors.black,
      )),
      primaryColor: primary,
      backgroundColor: bg,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      cardColor: cardColor,
      bottomAppBarColor: cardColor,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: bg,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        elevation: 8,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: cardColor,
      ),
      cardTheme: const CardTheme(
        color: cardColor,
      ),
    );
  }

  static ThemeData get themeDark {
    // const bg = Color(0xff121212);
    const bg = Color(0xff121212);
    const cardColor = Color(0xff1e1e1e);
    const primary = Color(0xffff9f0a);
    const secondary = Color(0xff0a84ff);

    return ThemeData(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: primary,
        secondary: secondary,
      ),
      primaryColor: primary,
      brightness: Brightness.dark,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: Colors.white,
      )),
      backgroundColor: bg,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      cardColor: cardColor,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: bg,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        elevation: 8,
        selectedItemColor: primary,
      ),
      dialogTheme: const DialogTheme(backgroundColor: cardColor),
      cardTheme: const CardTheme(color: cardColor),
    );
  }
}

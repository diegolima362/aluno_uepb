import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    // const bg = Color(0xffffffff);
    const bg = Color(0xffffffff);
    // const cardColor = Color(0xffeeeeee);
    const cardColor = Color(0xffffffff);

    const primary = Color(0xffaf52de);
    const secondary = Color(0xff34c759);

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
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: cardColor,
      ),
      cardTheme: const CardTheme(
        color: cardColor,
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            headline1: GoogleFonts.firaCode(
                fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            headline2: GoogleFonts.firaCode(
                fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            headline3: GoogleFonts.firaCode(
                fontSize: 48, fontWeight: FontWeight.w400, letterSpacing: 0),
            headline4: GoogleFonts.firaCode(
                fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headline5: GoogleFonts.firaCode(
                fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
            headline6: GoogleFonts.firaCode(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: GoogleFonts.firaCode(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: GoogleFonts.firaCode(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyText2: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: GoogleFonts.firaCode(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            overline: GoogleFonts.firaCode(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ),
    );
  }

  static ThemeData get themeDark {
    // const bg = Color(0xff121212);
    const bg = Color(0xff121212);
    const cardColor = Color(0xff1e1e1e);

    const primary = Color(0xff9965f4);
    const secondary = Color(0xff30d158);

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
        selectedItemColor: primary,
      ),
      dialogTheme: const DialogTheme(backgroundColor: cardColor),
      cardTheme: const CardTheme(color: cardColor),
      textTheme: ThemeData.dark().textTheme.copyWith(
            headline1: GoogleFonts.firaCode(
                fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
            headline2: GoogleFonts.firaCode(
                fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5),
            headline3: GoogleFonts.firaCode(
                fontSize: 48, fontWeight: FontWeight.w400, letterSpacing: 0),
            headline4: GoogleFonts.firaCode(
                fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            headline5: GoogleFonts.firaCode(
                fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0),
            headline6: GoogleFonts.firaCode(
                fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
            subtitle1: GoogleFonts.firaCode(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
            subtitle2: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
            bodyText1: GoogleFonts.firaCode(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
            bodyText2: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
            button: GoogleFonts.firaCode(
                fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
            caption: GoogleFonts.firaCode(
                fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
            overline: GoogleFonts.firaCode(
                fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
          ),
    );
  }
}

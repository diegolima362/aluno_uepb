import 'package:flutter/material.dart';

class CustomThemes {
  static Color accentColor = Colors.pink[900];

  static void setColor(Color color) {
    accentColor = color;
  }

  static ThemeData get light => ThemeData(
        cursorColor: accentColor,
        textSelectionColor: accentColor.withAlpha(100),
        textSelectionHandleColor: accentColor,
        primaryColor: accentColor,
        primaryColorDark: Colors.blueGrey,
        primaryColorBrightness: Brightness.light,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
        ),
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        cardTheme: CardTheme(color: Color(0xFFF3F2FD)),
        accentColor: accentColor,
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
      );

  static ThemeData get dark => ThemeData(
        primaryColor: Colors.grey,
        primaryColorBrightness: Brightness.dark,
        primaryColorDark: Colors.blueGrey,
        cursorColor: Colors.white70,
        textSelectionColor: Colors.blueGrey[600],
        textSelectionHandleColor: Colors.white70,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Color(0xFF101010),
        ),
        toggleableActiveColor: accentColor,
        backgroundColor: Colors.black87,
        canvasColor: Color(0xFF101010),
        cardTheme: CardTheme(color: Color(0xFF252525)),
        accentColor: accentColor,
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
      );
}

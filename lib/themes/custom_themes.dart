import 'package:flutter/material.dart';

class CustomThemes {
  static ThemeData get light => ThemeData(
        cursorColor: Colors.black87,
        textSelectionColor: Colors.blueGrey[200],
        textSelectionHandleColor: Colors.black87,
        primaryColor: Colors.black,
        primaryColorDark: Colors.blueGrey,
        primaryColorBrightness: Brightness.light,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Color(0xFFCCCCCC),
        ),
        backgroundColor: Color(0xFFCCCCCC),
        canvasColor: Color(0xFFCCCCCC),
        cardTheme: CardTheme(color: Color(0xFFEEEEEE)),
        accentColor: Colors.black54,
        brightness: Brightness.light,
        primarySwatch: Colors.grey,
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
        toggleableActiveColor: Colors.grey,
        backgroundColor: Colors.black87,
        canvasColor: Color(0xFF101010),
        cardTheme: CardTheme(color: Color(0xFF252525)),
        accentColor: Colors.white70,
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      );
}

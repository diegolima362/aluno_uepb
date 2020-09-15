import 'package:flutter/material.dart';

class CustomThemes {
  static Color accentColor = Color(0xFF505050);
  static Color defaultaAccentColor = Color(0xFF505050);

  static Map<int, Color> swash = {
    50: accentColor.withOpacity(.1),
    100: accentColor.withOpacity(.2),
    200: accentColor.withOpacity(.3),
    300: accentColor.withOpacity(.4),
    400: accentColor.withOpacity(.5),
    500: accentColor.withOpacity(.6),
    600: accentColor.withOpacity(.7),
    700: accentColor.withOpacity(.8),
    800: accentColor.withOpacity(.9),
    900: accentColor.withOpacity(1),
  };

  static void setColor(Color color) => accentColor = color;

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
        cardTheme: const CardTheme(color: const Color(0xEEFFFFFF)),
        accentColor: accentColor,
        brightness: Brightness.light,
        primarySwatch: MaterialColor(accentColor.value, swash),
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
          color: Colors.black,
        ),
        dialogBackgroundColor: const Color(0xFF101010),
        toggleableActiveColor: accentColor,
        backgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardTheme: const CardTheme(
          color: const Color.fromARGB(255, 25, 25, 25),
          shadowColor: const Color(0xFFAAAAAA),
        ),
        accentColor: accentColor,
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(accentColor.value, swash),
      );
}

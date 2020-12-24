import 'package:flutter/material.dart';

class CustomThemes {
  CustomThemes._();

  static Color darkAccentColor = Color(0xFFE43F5A);
  static Color lightAccentColor = Color(0xFF1A1A1A);

  // static Color lightAccentColor = Color(0xFF1D3557);

  static Map<int, Color> _getSwash(Color accentColor) {
    return {
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
  }

  static ThemeData get light {
    final white = Color(0xFFF7F6F1);

    // final otherWhite = Color(0xFFFEFEFE);
    // final red = Color(0xFFE63946);
    final textColor = Color(0xFF1A1A1A);
    final accent = lightAccentColor;
    final primary = lightAccentColor;
    final disableIcon = primary.withOpacity(0.5);
    final selectedColor = lightAccentColor;
    final cardColor = Color(0xFFFFFFFF);
    final buttonColor = lightAccentColor;
    final iconColor = lightAccentColor;
    final dividerColor = Color(0xFFDDDDDD);
    final anotherWhite = Color(0xFFAAAAAA);
    final swash = MaterialColor(accent.value, _getSwash(accent));

    return ThemeData(
      primarySwatch: swash,
      brightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      indicatorColor: textColor,
      backgroundColor: white,
      primaryColor: primary,
      buttonColor: buttonColor,
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      accentColor: accent,
      canvasColor: white,
      disabledColor: disableIcon,
      iconTheme: IconThemeData(color: iconColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: white,
        unselectedIconTheme: IconThemeData(color: disableIcon),
        selectedIconTheme: IconThemeData(color: selectedColor),
      ),
      cardTheme: CardTheme(color: cardColor),
      dividerColor: dividerColor,
      textTheme: TextTheme(
        button: TextStyle(
          color: white,
        ),
        subtitle2: TextStyle(
          color: anotherWhite,
        ),
        subtitle1: TextStyle(
          color: textColor,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
        bodyText2: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: textColor,
        foregroundColor: white,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: textColor),
        actionsIconTheme: IconThemeData(color: textColor),
        color: white,
        brightness: Brightness.light,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 24.0,
            color: textColor,
          ),
        ),
        elevation: 0,
      ),
    );
  }

  static ThemeData get dark {
    final white = Color(0xFFFEFEFE);
    final dark = Color(0xFF121212);
    // final otherWhite = Color(0xFFFEFEFE);
    // final red = Color(0xFFE63946);
    final textColor = Color(0xFFEEEEEE);
    final accent = darkAccentColor;
    final primary = darkAccentColor;
    final disableIcon = primary.withOpacity(0.5);
    final selectedColor = darkAccentColor;
    final cardColor = Color(0xFF202523);
    final buttonColor = darkAccentColor;
    final iconColor = darkAccentColor;
    final dividerColor = Color(0xFF121212);
    final anotherWhite = Color(0xFFAAAAAA);
    final swash = MaterialColor(accent.value, _getSwash(accent));

    return ThemeData(
      primarySwatch: swash,
      brightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      indicatorColor: textColor,
      toggleableActiveColor: accent,
      backgroundColor: dark,
      primaryColor: primary,
      buttonColor: buttonColor,
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      accentColor: accent,
      canvasColor: dark,
      disabledColor: disableIcon,
      iconTheme: IconThemeData(color: iconColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: dark,
        unselectedIconTheme: IconThemeData(color: disableIcon),
        selectedIconTheme: IconThemeData(color: selectedColor),
      ),
      cardTheme: CardTheme(color: cardColor),
      dividerColor: dividerColor,
      textTheme: TextTheme(
        button: TextStyle(
          color: white,
        ),
        subtitle2: TextStyle(
          color: anotherWhite,
        ),
        subtitle1: TextStyle(
          color: textColor,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
        bodyText2: TextStyle(
          fontSize: 16.0,
          color: textColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: iconColor,
        foregroundColor: dark,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: textColor),
        actionsIconTheme: IconThemeData(color: textColor),
        color: dark,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 24.0,
            color: accent,
          ),
        ),
        elevation: 0,
      ),
    );
  }
}

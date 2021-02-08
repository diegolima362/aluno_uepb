import 'package:flutter/material.dart';

class CustomThemes {
  List<Color> get darkAccentColores => [
        const Color(0xffe43f5a),
        const Color(0xfff0f0f0),
        const Color(0xff77e2c3),
        const Color(0xffffaf7b),
        const Color(0xfff8ca4d),
        const Color(0xffd9583b),
        const Color(0xff2a9d8f),
        const Color(0xff2979ff),
      ];

  List<Color> get lightAccentColores => [
        const Color(0xff141414),
        const Color(0xffe43f5a),
        const Color(0xff24314d),
        const Color(0xffd9583b),
        const Color(0xff2a9d8f),
        const Color(0xff2979ff),
        const Color(0xff006d77),
        const Color(0xff4d194d),
      ];

  ThemeData getDark({int colorValue}) {
    Color accent = darkAccentColores[0];

    if (colorValue != null) {
      final accentColor = Color(colorValue);

      if (accentColor.alpha != 0) {
        accent = accentColor;
      }
    }

    final bg = Color(0xff141414);

    // final otherWhite = Color(0xFFFEFEFE);
    final textColor = Color(0xffe8e8e8);
    final appBarTitle = Color(0xffe8e8e8);
    // final titleColor = Color(0xffe8e8e8);
    // final dark = Color(0xff495464);
    final primary = accent;
    // final disableIcon = primary.withOpacity(0.5);
    final selectedColor = accent;
    final cardColor = Color(0xff1a1a1a);
    // final barColor = Color(0xff212121);
    // final bottomBar = Color(0xff1f1f1f);
    final buttonColor = accent;
    final iconColor = accent;
    final dividerColor = Color(0xff303030);
    final subtitle = Color(0xff495464);
    final splash = accent;
    final swash = MaterialColor(accent.value, _getSwash(accent));

    return ThemeData(
      primarySwatch: swash,
      brightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      indicatorColor: textColor,
      backgroundColor: bg,
      primaryColor: primary,
      buttonColor: buttonColor,
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.normal,
      ),
      accentColor: accent,
      canvasColor: bg,
      // disabledColor: disableIcon,
      iconTheme: IconThemeData(color: iconColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bg,
        // unselectedIconTheme: IconThemeData(color: disableIcon),
        selectedIconTheme: IconThemeData(color: selectedColor),
      ),
      cardColor: cardColor,
      cardTheme: CardTheme(color: cardColor),
      dividerColor: dividerColor,
      splashColor: splash,
      textTheme: TextTheme(
        button: TextStyle(
          color: bg,
        ),
        subtitle2: TextStyle(
          color: subtitle,
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
      dialogBackgroundColor: cardColor,
      dialogTheme: DialogTheme(backgroundColor: cardColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        hoverColor: subtitle,
        focusColor: subtitle,
        foregroundColor: bg,
        elevation: 2,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: iconColor),
        actionsIconTheme: IconThemeData(color: iconColor),
        color: bg,
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20.0,
            color: appBarTitle,
          ),
        ),
        elevation: 1.0,
      ),
    );
  }

  ThemeData getLight({int colorValue}) {
    Color accent = lightAccentColores[0];

    if (colorValue != null) {
      final accentColor = Color(colorValue);

      if (accentColor.alpha != 0) {
        accent = accentColor;
      }
    }

    final bg = Color(0xfffafafa);

    // final otherWhite = Color(0xFFFEFEFE);
    final textColor = Color(0xff141414);
    // final appBarTitle = Color(0xff1a1a1a);

    // final dark = Color(0xff495464);
    final primary = accent;
    // final disableIcon = primary.withOpacity(0.5);
    final selectedColor = accent;
    final cardColor = Color(0xffffffff);
    // final barColor = accent;
    final buttonColor = accent;
    final iconColor = accent;
    final dividerColor = Color(0xffbbbbbb);
    final subtitle = Color(0xff3a3a3a);
    final splash = accent;
    final swash = MaterialColor(accent.value, _getSwash(accent));

    return ThemeData(
      cardColor: cardColor,
      primarySwatch: swash,
      brightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      indicatorColor: textColor,
      backgroundColor: bg,
      primaryColor: primary,
      buttonColor: buttonColor,
      buttonTheme: ButtonThemeData(
        buttonColor: buttonColor,
        textTheme: ButtonTextTheme.normal,
      ),
      accentColor: accent,
      canvasColor: bg,
      // disabledColor: disableIcon,
      iconTheme: IconThemeData(color: iconColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bg,
        // unselectedIconTheme: IconThemeData(color: disableIcon),
        selectedIconTheme: IconThemeData(color: selectedColor),
      ),
      cardTheme: CardTheme(color: cardColor),
      dividerColor: dividerColor,
      splashColor: splash,
      textTheme: TextTheme(
        button: TextStyle(
          color: bg,
        ),
        subtitle2: TextStyle(
          color: subtitle,
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
      dialogBackgroundColor: cardColor,
      dialogTheme: DialogTheme(backgroundColor: cardColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        hoverColor: subtitle,
        focusColor: subtitle,
        foregroundColor: bg,
        elevation: 2,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: iconColor),
        actionsIconTheme: IconThemeData(color: iconColor),
        color: bg,
        brightness: Brightness.light,
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 20.0,
            color: textColor,
          ),
        ),
        elevation: 1.0,
        shadowColor: textColor,
      ),
    );
  }

  // static Color lightAccentColor = Color(0xFF1D3557);

  Map<int, Color> _getSwash(Color accentColor) {
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
}

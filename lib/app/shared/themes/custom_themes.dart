import 'package:flutter/material.dart';

class CustomThemes {
  static const Color white = Color(0xfff2f2f7);
  static const Color black = Color(0xff1c1c1e);

  List<Color> get darkAccentColors => [
        const Color(0xfff2f2f7),
        const Color(0xff0a84ff),
        const Color(0xff30d158),
        const Color(0xff5e5ce6),
        const Color(0xffff9f0a),
        const Color(0xffff375f),
        const Color(0xffff453a),
        const Color(0xff64d2ff),
      ];

  List<Color> get lightAccentColors => [
        const Color(0xff1c1c1e),
        const Color(0xff007bff),
        const Color(0xff34c759),
        const Color(0xff5856d6),
        const Color(0xffff9500),
        const Color(0xffff2d55),
        const Color(0xffff3b30),
        const Color(0xff5ac8fa),
      ];

  ThemeData getDark({int colorValue = 0xfff2f2f7}) {
    Color accent = darkAccentColors[0];

    final accentColor = Color(colorValue);

    if (accentColor.alpha != 0) {
      accent = accentColor;
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
    final cardColor = Color(0xff1c1c1e);
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

  ThemeData getLight({int colorValue = 0xff141414}) {
    Color accent = lightAccentColors[0];

    final accentColor = Color(colorValue);

    if (accentColor.alpha != 0) {
      accent = accentColor;
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

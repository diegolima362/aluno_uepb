import 'package:flutter/material.dart';

class CustomThemes {
  static bool isDark = false;
  static Color accentColor = Color(0xFF273c75);
  static Color defaultAccentColor = Color(0xFF273c75);

  static Color anotherWhite = Color(0xEff5f6fa);
  static Color white = Color(0xFFf5f6fa);
  static Color black = Colors.black;
  static Color anotherBlack = Color(0xFF191919);

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
        primaryColorDark: anotherBlack,
        primaryColorBrightness: Brightness.light,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: white,
        ),
        dialogBackgroundColor: white,
        backgroundColor: white,
        canvasColor: white,
        cardTheme: CardTheme(color: anotherWhite),
        accentColor: accentColor,
        brightness: Brightness.light,
        primarySwatch: MaterialColor(accentColor.value, swash),
        toggleableActiveColor: accentColor,
      );

  static ThemeData get dark => ThemeData(
        primaryColor: anotherWhite,
        primaryColorBrightness: Brightness.dark,
        primaryColorDark: anotherBlack,
        cursorColor: anotherWhite,
        textSelectionColor: anotherWhite.withAlpha(100),
        textSelectionHandleColor: white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: black,
        ),
        dialogBackgroundColor: anotherBlack,
        toggleableActiveColor: accentColor,
        backgroundColor: black,
        canvasColor: black,
        cardTheme: CardTheme(
          color: anotherBlack,
          shadowColor: defaultAccentColor,
        ),
        accentColor: accentColor,
        brightness: Brightness.dark,
        primarySwatch: MaterialColor(accentColor.value, swash),
      );

  static List<Color> get accentColors => [
        const Color(0xFF00b894),
        const Color(0xFF0984e3),
        const Color(0xFF192a56),
        const Color(0xFF218c74),
        const Color(0xFF2f3542),
        const Color(0xFF44bd32),
        const Color(0xFF487eb0),
        const Color(0xFF6D214F),
        Colors.deepPurple,
        Colors.pink,
        const Color(0xFFB33771),
        const Color(0xFFd63031),
        const Color(0xFFe84118),
        const Color(0xFFff4757),
        const Color(0xFFffa502),
        Colors.brown
      ];

  static List<Color> get accentColorsDark => [
        const Color(0xFF00b894),
        const Color(0xFF0984e3),
        const Color(0xFF218c74),
        const Color(0xFF227093),
        const Color(0xFF273c75),
        const Color(0xFF2ed573),
        const Color(0xFF6D214F),
        const Color(0xFF74b9ff),
        const Color(0xFFb2bec3),
        const Color(0xFFd63031),
        const Color(0xFFe84118),
        Colors.cyan,
        Colors.amber,
        Colors.pink,
        Colors.lightGreenAccent,
        Colors.blueGrey,
      ];
}

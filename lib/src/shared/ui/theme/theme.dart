import 'package:flutter/material.dart';

const transitions = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
  },
);

ThemeData lightTheme(Color seedColor, ColorScheme? colorScheme) {
  final scheme = colorScheme ??
      ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        primary: seedColor == Colors.black ? seedColor : null,
      );

  return ThemeData.light(useMaterial3: true).copyWith(
    useMaterial3: true,
    colorScheme: scheme,
    primaryColor: Colors.black,
    pageTransitionsTheme: transitions,
    dialogBackgroundColor: scheme.surface,
    scaffoldBackgroundColor: scheme.surface,
    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      elevation: 3,
    ),
    cardTheme: CardTheme(
      color: scheme.surface,
      elevation: 1,
    ),
  );
}

ThemeData darkTheme(Color seedColor, ColorScheme? colorScheme) {
  final scheme = colorScheme ??
      ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
        primary: seedColor == Colors.white ? seedColor : null,
      );

  return ThemeData.dark(useMaterial3: true).copyWith(
    useMaterial3: true,
    colorScheme: scheme,
    primaryColor: Colors.white,
    pageTransitionsTheme: transitions,
    dialogBackgroundColor: scheme.surface,
    scaffoldBackgroundColor: scheme.surface,
    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      elevation: 3,
    ),
    cardTheme: CardTheme(
      color: scheme.surface,
      elevation: 1,
    ),
  );
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

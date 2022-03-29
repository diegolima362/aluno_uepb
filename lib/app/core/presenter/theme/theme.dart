import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme(Color seedColor, {bool darkMode = false}) {
    late Brightness brightness;

    if (darkMode) {
      brightness = Brightness.dark;
    } else {
      brightness = Brightness.light;
    }

    final scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: scheme.primary,
      useMaterial3: true,
      colorScheme: scheme,
      indicatorColor: scheme.secondary,
      appBarTheme: AppBarTheme(
        elevation: 0,
        toolbarHeight: 64,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        iconTheme: IconThemeData(
          color: scheme.onSurface,
        ),
        actionsIconTheme: IconThemeData(
          color: scheme.onSurfaceVariant,
        ),
      ),
      canvasColor: scheme.background,
      backgroundColor: scheme.background,
      cardTheme: CardTheme(
        color: scheme.surfaceVariant,
        shadowColor: scheme.shadow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
          textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
                color: scheme.primary,
                fontSize: 14,
                letterSpacing: 0.1,
                fontWeight: FontWeight.w500,
              )),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 1),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.surface,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.surface,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => scheme.primary,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.secondaryContainer.withOpacity(0.25),
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: MaterialStateProperty.resolveWith(
          (_) => TextStyle(
            color: scheme.onSurface,
          ),
        ),
        iconTheme: MaterialStateProperty.resolveWith(
          (_) => IconThemeData(
            color: scheme.onSecondaryContainer,
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        elevation: 3,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 24,
        ),
        contentTextStyle: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 14,
          letterSpacing: 0.25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.resolveWith((_) => scheme.secondary),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((_) => scheme.secondary),
      ),
    );
  }
}

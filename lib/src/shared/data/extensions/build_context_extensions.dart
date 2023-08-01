import 'package:flutter/material.dart';

extension AlertsUtil on BuildContext {
  void showMessage(
    String message, [
    Function? onClosed,
    SnackBarAction? action,
  ]) {
    ScaffoldMessenger.of(this)
        .showSnackBar(SnackBar(
          content: Text(message),
          action: action,
        ))
        .closed
        .then((_) async => onClosed?.call());
  }

  void showError(
    String message, [
    Function? onClosed,
  ]) {
    ScaffoldMessenger.of(this)
        .showSnackBar(SnackBar(
          content: Text(
            message,
            style: TextStyle(color: colors.onErrorContainer),
          ),
          backgroundColor: colors.errorContainer,
        ))
        .closed
        .then((_) async => onClosed?.call());
  }

  void showErrorWithAction(
    String message, {
    required String label,
    required void Function() onPressed,
    Function? onClosed,
  }) {
    ScaffoldMessenger.of(this)
        .showSnackBar(SnackBar(
          content: Text(
            message,
            style: TextStyle(color: colors.onErrorContainer),
          ),
          backgroundColor: colors.errorContainer,
          action: SnackBarAction(
            label: label,
            onPressed: onPressed,
            textColor: colors.errorContainer,
            backgroundColor: colors.onErrorContainer,
          ),
        ))
        .closed
        .then((_) async => onClosed?.call());
  }
}

extension TypographyUtils on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colors => theme.colorScheme;

  bool get isDark => theme.brightness == Brightness.dark;

  TextStyle? get displayLarge => textTheme.displayLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get displayMedium => textTheme.displayMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get displaySmall => textTheme.displaySmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineLarge => textTheme.headlineLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineMedium => textTheme.headlineMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get headlineSmall => textTheme.headlineSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleLarge => textTheme.titleLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleMedium => textTheme.titleMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get titleSmall => textTheme.titleSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelLarge => textTheme.labelLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelMedium => textTheme.labelMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get labelSmall => textTheme.labelSmall?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodyLarge => textTheme.bodyLarge?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodyMedium => textTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
      );
  TextStyle? get bodySmall => textTheme.bodySmall?.copyWith(
        color: colors.onSurface,
      );
}

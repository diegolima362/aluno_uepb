import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const CustomChip({
    Key? key,
    required this.text,
    this.active = false,
    this.onPressed,
    this.padding,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final color = active
        ? theme.colorScheme.secondary
        : theme.disabledColor.withAlpha(isDark ? 50 : 0x1f);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        child: Padding(
          padding:
              padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: active ? theme.colorScheme.onSecondary : null,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
      ),
    );
  }
}

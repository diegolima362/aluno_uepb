import 'package:flutter/material.dart';

class MyAppIcon extends StatelessWidget {
  final double _padding;
  final double fontSize;

  const MyAppIcon({super.key})
      : fontSize = 32,
        _padding = 8;

  const MyAppIcon.small({super.key})
      : fontSize = 24,
        _padding = 4;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
          fontSize: fontSize,
        );

    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Text(
        'uepb',
        style: style,
      ),
    );
  }
}

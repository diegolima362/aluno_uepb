import 'package:flutter/material.dart';

class TextOption extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double fontSize;

  const TextOption(
    this.text, {
    Key? key,
    this.textColor,
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.labelLarge?.copyWith(color: textColor),
      ),
      onPressed: null,
    );
  }
}

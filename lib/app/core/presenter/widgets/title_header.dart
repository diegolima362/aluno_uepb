import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  final String text;
  final double? fontSize;

  const TitleHeader({Key? key, required this.text, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ColorContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;
  final int? colorValue;
  final bool useBorder;

  const ColorContainer({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
    this.colorValue,
    this.useBorder = false,
  })  : assert(color != null || colorValue != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Color(colorValue!),
        shape: BoxShape.circle,
        border: !useBorder
            ? null
            : Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                width: 1,
              ),
      ),
    );
  }
}

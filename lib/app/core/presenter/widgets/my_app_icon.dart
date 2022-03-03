import 'package:flutter/material.dart';

class MyAppIcon extends StatelessWidget {
  final double width;
  final double height;

  const MyAppIcon({Key? key, this.width = 75, this.height = 75})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final asset = Theme.of(context).brightness == Brightness.dark
        ? 'splash-invert'
        : 'splash';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/$asset.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

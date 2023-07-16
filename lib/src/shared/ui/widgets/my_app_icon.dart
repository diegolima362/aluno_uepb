import 'package:flutter/material.dart';

class MyAppIcon extends StatelessWidget {
  final double width;
  final double height;

  const MyAppIcon({super.key, this.width = 75, this.height = 75});

  @override
  Widget build(BuildContext context) {
    final asset = Theme.of(context).brightness == Brightness.dark
        ? 'app_logo_invert'
        : 'app_logo';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/$asset.png',
          width: width,
          height: height,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

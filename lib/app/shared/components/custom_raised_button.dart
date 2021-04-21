import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final ShapeBorder? shape;
  final double height;
  final VoidCallback? onPressed;

  const CustomRaisedButton({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50.0,
    this.onPressed,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _color = color ?? Theme.of(context).buttonColor;
    // final _color = color ?? Theme.of(context).buttonColor;

    return SizedBox(
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color ?? Colors.blue),
        ),
      ),
      height: height,
    );
  }
}

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color,
    this.disabledColor: Colors.blueGrey,
    this.borderRadius: 5.0,
    this.height: 50.0,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final Color disabledColor;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: disabledColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
      height: height,
    );
  }
}

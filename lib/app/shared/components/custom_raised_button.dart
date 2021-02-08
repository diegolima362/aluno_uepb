import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final ShapeBorder shape;

  final Widget child;

  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  CustomRaisedButton({
    Key key,
    this.child,
    this.color,
    this.borderRadius: 2.0,
    this.height: 50.0,
    this.onPressed,
    this.shape,
  })  : assert(borderRadius != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = color ?? Theme.of(context).buttonColor;
    // final _color = color ?? Theme.of(context).buttonColor;

    return SizedBox(
      child: RaisedButton(
        child: child,
        color: _color,
        // textColor: _textColor,
        shape: shape ??
            RoundedRectangleBorder(
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

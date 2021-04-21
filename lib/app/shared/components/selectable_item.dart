import 'package:flutter/material.dart';

class SelectableItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final Color? bgColor;
  final Color? textColor;
  final double? size;
  final Widget? child;
  final String text;
  final bool active;
  final EdgeInsetsGeometry? margin;

  const SelectableItem({
    Key? key,
    required this.text,
    required this.active,
    this.onTap,
    this.bgColor,
    this.textColor,
    this.size,
    this.child,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bg = bgColor ?? Theme.of(context).canvasColor;
    final _fg = textColor ?? Theme.of(context).accentColor;
    final _margin = margin ?? EdgeInsets.symmetric(horizontal: 4);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: _margin,
        decoration: BoxDecoration(
          color: active ? _fg : _bg,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _fg,
            width: 2,
          ),
        ),
        height: 30,
        width: 30,
        child: Center(
          child: child ??
              Text(
                text,
                style: TextStyle(color: active ? _bg : _fg),
              ),
        ),
      ),
    );
  }
}

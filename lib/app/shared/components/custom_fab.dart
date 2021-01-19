import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final bool extended;
  final String tooltip;
  final Icon icon;
  final String label;
  final Function onPressed;
  final Color color;

  const CustomFAB(
      {Key key,
      this.extended,
      this.tooltip,
      this.icon,
      this.label,
      this.onPressed,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1),
      transitionBuilder: (child, animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).accentColor,
          ),
          borderRadius: extended ? BorderRadius.circular(50) : null,
          shape: extended ? BoxShape.rectangle : BoxShape.circle,
        ),
        child: FloatingActionButton.extended(
          backgroundColor: color ?? Theme.of(context).canvasColor,
          foregroundColor: Theme.of(context).accentColor,
          onPressed: onPressed,
          tooltip: tooltip,
          label: extended ? Text(label) : icon,
          isExtended: extended,
          icon: extended ? icon : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final bool extended;
  final String? tooltip;
  final Icon icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  const CustomFAB({
    Key? key,
    required this.icon,
    required this.label,
    this.extended = true,
    this.tooltip,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final fg = const Color(0xfffbfbfb);
    final cardColor = Theme.of(context).cardTheme.color!;
    final bg = darkMode ? cardColor : accent;

    return FloatingActionButton.extended(
      shape: darkMode
          ? StadiumBorder(side: BorderSide(color: const Color(0xff303030), width: 1))
          : null,
      backgroundColor: bg,
      onPressed: onPressed,
      tooltip: tooltip,
      label: extended ? Text(label) : icon,
      isExtended: extended,
      foregroundColor: fg,
      icon: extended ? icon : null,
    );
  }
}

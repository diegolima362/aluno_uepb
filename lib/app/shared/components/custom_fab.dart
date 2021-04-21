import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
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
    final fg = accent == CustomThemes.white ? null : Colors.white;
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      label: extended ? Text(label) : icon,
      isExtended: extended,
      foregroundColor: fg,
      icon: extended ? icon : null,
    );
  }
}

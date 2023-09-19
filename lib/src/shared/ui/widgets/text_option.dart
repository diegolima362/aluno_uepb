import 'package:flutter/material.dart';

import '../../domain/extensions/build_context_extensions.dart';

class TextOption extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? leading;
  final String label;
  final bool selected;

  const TextOption({
    super.key,
    this.onTap,
    this.leading,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      trailing: const SizedBox.shrink(),
      leading: leading ?? const SizedBox.shrink(),
      title: Text(
        label,
        style: TextStyle(color: selected ? context.colors.primary : null),
      ),
      onTap: onTap,
    );
  }
}

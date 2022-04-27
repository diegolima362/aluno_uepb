import 'package:flutter/material.dart';

import 'custom_dialog.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode initialValue;
  final void Function(ThemeMode?) onThemeSelected;

  const ThemeSelector({
    Key? key,
    required this.initialValue,
    required this.onThemeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAlert<ThemeMode>(
      title: 'Escolher tema',
      initialValue: initialValue,
      onValueChanged: onThemeSelected,
      contentBuilder: (update, value) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Claro'),
            contentPadding: EdgeInsets.zero,
            onTap: () => update(ThemeMode.light),
            leading: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: value,
              onChanged: (newValue) => update(newValue),
            ),
          ),
          ListTile(
            title: const Text('Escuro'),
            contentPadding: EdgeInsets.zero,
            onTap: () => update(ThemeMode.dark),
            leading: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: value,
              onChanged: (newValue) => update(newValue),
            ),
          ),
          ListTile(
            title: const Text('Pelo sistema'),
            contentPadding: EdgeInsets.zero,
            onTap: () => update(ThemeMode.system),
            leading: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: value,
              onChanged: (newValue) => update(newValue),
            ),
          ),
        ],
      ),
    );
  }
}

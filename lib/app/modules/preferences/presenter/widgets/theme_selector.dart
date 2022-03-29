import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final Function(ThemeMode?) onSetTheme;
  final ThemeMode initialTheme;

  const ThemeSelector(
      {Key? key,
      required this.onSetTheme,
      this.initialTheme = ThemeMode.system})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = List.generate(3, (index) => index == initialTheme.index);
    return ListTile(
      title: const Text(
        'Tema ',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: ToggleButtons(
        isSelected: selected,
        borderRadius: BorderRadius.circular(4),
        onPressed: (index) => onSetTheme(ThemeMode.values.elementAt(index)),
        children: const [
          Icon(Icons.phone_android_sharp),
          Icon(Icons.wb_sunny_outlined),
          Icon(Icons.nightlight_round),
        ],
      ),
    );
  }
}

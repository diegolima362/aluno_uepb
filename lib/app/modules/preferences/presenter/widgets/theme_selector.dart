import 'package:flutter/cupertino.dart';
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
    return ListTile(
      title: const Text(
        'Tema ',
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      ),
      trailing: CupertinoSlidingSegmentedControl<ThemeMode>(
        groupValue: initialTheme,
        onValueChanged: onSetTheme,
        padding: EdgeInsets.zero,
        children: const {
          ThemeMode.system: Icon(Icons.phone_android_sharp),
          ThemeMode.light: Icon(Icons.wb_sunny_outlined),
          ThemeMode.dark: Icon(Icons.nightlight_round),
        },
      ),
    );
  }
}

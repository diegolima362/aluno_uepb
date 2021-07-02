import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final void Function() onSave;

  const SaveButton({Key? key, required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final accent = Theme.of(context).accentColor;
    final fg = const Color(0xfffbfbfb);
    final cardColor = Theme.of(context).cardTheme.color;
    final bg = darkMode ? cardColor : accent;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bg),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: darkMode ? fg : accent),
            ),
          ),
        ),
        child: Text(
          'Salvar',
          style: TextStyle(color: fg,fontSize: 18),
        ),
        onPressed: onSave,
      ),
    );
  }
}

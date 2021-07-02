import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  final List<Color> colors;
  final void Function(Color) onTap;
  final Color initialColor;

  const ColorPickerDialog({
    Key? key,
    required this.colors,
    required this.onTap,
    required this.initialColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 120,
        width: 120,
        child: ColorPicker(
          colors: colors,
          selectedColor: initialColor,
          onTap: onTap,
        ),
      ),
    );
  }
}

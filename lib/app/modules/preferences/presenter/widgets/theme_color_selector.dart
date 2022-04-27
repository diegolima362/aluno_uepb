import 'package:aluno_uepb/app/core/presenter/theme/colors.dart';
import 'package:flutter/material.dart';

import 'color_container.dart';
import 'custom_dialog.dart';

class ThemeColorSelector extends StatelessWidget {
  final int? initialValue;
  final void Function(int?) onColorSelected;

  const ThemeColorSelector({
    Key? key,
    this.initialValue,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAlert<int>(
      title: 'Escolher cor',
      initialValue: initialValue,
      onValueChanged: onColorSelected,
      contentBuilder: (update, value) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: appColors
              .map(
                (e) => GestureDetector(
                  onTap: () => update(e.value),
                  child: ColorContainer(
                    color: e,
                    useBorder: value == e.value,
                    width: 48,
                    height: 48,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

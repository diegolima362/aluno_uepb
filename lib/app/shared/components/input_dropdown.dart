import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  final String? labelText;
  final String valueText;
  final TextStyle? valueStyle;
  final VoidCallback? onPressed;

  const InputDropdown({
    Key? key,
    required this.valueText,
    this.labelText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

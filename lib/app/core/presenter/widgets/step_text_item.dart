import 'package:flutter/material.dart';

class StepTextItem extends StatelessWidget {
  final String label;
  final String value;

  const StepTextItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: textTheme.bodyLarge,
          children: [
            TextSpan(
              text: value,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

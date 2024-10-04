import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppBarTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          text: title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          children: [
            if (subtitle != null)
              TextSpan(
                text: '\n$subtitle',
                style: context.textTheme.titleSmall,
              ),
          ],
        ),
      ),
    );
  }
}

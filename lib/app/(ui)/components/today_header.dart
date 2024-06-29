import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';

class TodayHeader extends StatelessWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          today.dayOfWeek.capitalFirst,
          style: context.textTheme.headlineMedium,
        ),
        Text(
          today.simpleDate,
          style: context.textTheme.titleSmall,
        ),
      ],
    );
  }
}

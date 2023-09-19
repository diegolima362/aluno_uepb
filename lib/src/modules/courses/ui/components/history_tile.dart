import 'package:flutter/material.dart';

import '../../../../shared/domain/extensions/build_context_extensions.dart';
import '../../models/models.dart';

class HistoryTile extends StatelessWidget {
  final History history;

  const HistoryTile({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          history.name,
          style: context.textTheme.bodyMedium,
        ),
        if (history.professors.isNotEmpty)
          Tooltip(
            message: history.professors.join('\n'),
            child: Text(
              history.professors.first +
                  (history.professors.length > 1
                      ? ' +${history.professors.length - 1}'
                      : ''),
              style: context.textTheme.bodySmall,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CH: ${history.totalHours}',
              style: context.textTheme.labelMedium,
            ),
            if (history.credits.isNotEmpty)
              Text(
                'CR: ${history.credits}',
                style: context.textTheme.labelMedium,
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Média: ${history.grade}',
              style: context.textTheme.labelMedium,
            ),
            Text(
              'Status: ${history.status}',
              style: context.textTheme.labelMedium,
            ),
          ],
        ),
      ],
    );
  }
}

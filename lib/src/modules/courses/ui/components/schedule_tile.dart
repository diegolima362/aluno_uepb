import 'package:flutter/material.dart';

import '../../../../shared/data/extensions/extensions.dart';
import '../../models/models.dart';

class ScheduleTile extends StatelessWidget {
  final ClassAtDay info;

  const ScheduleTile({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          info.course,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleSmall,
        ),
        Tooltip(
          message: info.professors.join('\n'),
          child: Text(
            info.formattedProfessors,
            style: context.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 4),
            Container(
              decoration: ShapeDecoration(
                color: context.colors.secondaryContainer,
                shape: const StadiumBorder(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                info.formattedTime,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 4),
            Container(
              decoration: ShapeDecoration(
                color: context.colors.secondaryContainer,
                shape: const StadiumBorder(),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Tooltip(
                message: info.local,
                child: Text(
                  info.localShort.isNotEmpty ? info.localShort : info.local,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

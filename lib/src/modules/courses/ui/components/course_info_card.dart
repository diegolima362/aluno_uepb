import 'package:flutter/material.dart';

import '../../../../shared/data/extensions/build_context_extensions.dart';
import '../../models/extensions.dart';
import '../../models/models.dart';

class CourseInfoCard extends StatelessWidget {
  final Course course;

  const CourseInfoCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          course.title,
          style: context.textTheme.titleMedium,
        ),
        if (course.professors.isNotEmpty)
          Tooltip(
            message: course.professors.join('\n'),
            child: Text(
              course.professors.first +
                  (course.professors.length > 1
                      ? ' +${course.professors.length - 1}'
                      : ''),
              style: context.textTheme.titleSmall,
            ),
          ),
        if (course.credits != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text('CH • ${course.totalHours}'),
                const Spacer(),
                Text('${course.credits} Créditos'),
              ],
            ),
          )
        else
          const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${course.absences}${course.absenceLimit != 0 ? '/${course.absenceLimit}' : ''} Faltas',
            ),
            if (course.credits == 0) ...[
              const Spacer(),
              Text('${course.totalHours}h'),
            ]
          ],
        ),
        if (course.absenceLimit != 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: LinearProgressIndicator(
              value: course.absences / course.absenceLimit,
              color: course.absences > course.absenceLimit
                  ? context.colors.error
                  : null,
            ),
          ),
        const SizedBox(height: 8),
        if (course.schedule.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Horário',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ...course.schedule.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${e.dayOfWeek} • ${e.startTime + (e.endTime.isNotEmpty ? ' - ${e.endTime}' : '')}',
                ),
                const Spacer(),
                Expanded(
                    child: Tooltip(
                  message: e.local,
                  child: Text(
                    e.localShort.isNotEmpty ? e.localShort : e.local,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            ),
          ),
        ),
        if (course.grades.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Notas',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: course.grades
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          e.label + (e.weight.isNotEmpty ? ' ${e.weight}' : ''),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        Text(
                          (e.value.isEmpty ? '--' : e.value)
                              .replaceAll(',', '.'),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({
    super.key,
    this.height = 1.0,
    this.color,
  });
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.primary,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

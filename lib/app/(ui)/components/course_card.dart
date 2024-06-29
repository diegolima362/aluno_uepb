import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../interactor/models/course.dart';
import '../../interactor/models/extensions.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final titleStile = context.textTheme.titleMedium?.copyWith(
      color: context.colors.primary,
      fontWeight: FontWeight.w600,
      decorationStyle: TextDecorationStyle.dotted,
    );

    final subtitleStile = context.textTheme.titleMedium?.copyWith(
      color: context.colors.primary,
      fontWeight: FontWeight.w500,
    );

    final valueStyle = context.textTheme.bodyMedium?.copyWith(
      color: context.colors.primary,
      fontWeight: FontWeight.bold,
    );

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              course.name,
              textAlign: TextAlign.start,
              style: titleStile,
            ),
            if (course.professors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  course.professors.join('\n'),
                  textAlign: TextAlign.start,
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
                  backgroundColor: context.colors.primary.withOpacity(0.2),
                  color: course.absences > course.absenceLimit
                      ? context.colors.error
                      : null,
                ),
              ),
            const SizedBox(height: 8),
            if (course.schedule.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Horário',
                  style: subtitleStile,
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
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'Notas',
                  style: subtitleStile,
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
                              e.label +
                                  (e.weight.isNotEmpty ? ' ${e.weight}' : ''),
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
                              style: valueStyle,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
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

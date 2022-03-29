import 'dart:math';

import 'package:aluno_uepb/app/core/presenter/widgets/responsive.dart';
import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'custom_circular_progress.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback? onTap;

  const CourseInfoCard({
    Key? key,
    required this.course,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(course.name.toUpperCase(), style: textTheme.bodyLarge),
                Text(
                  course.professor.toUpperCase(),
                  style: textTheme.bodyMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(120, 120),
                          painter: CustomCircularProgress(
                            valueColor: theme.colorScheme.primary,
                            value:
                                min(course.absences / course.absencesLimit, 1),
                            arcSize: 90,
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 32),
                            Text(
                              '${course.absences}/${course.absencesLimit}\nFaltas',
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${course.duration}h',
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                _CourseInfoCardSchedule(course: course),
                const SizedBox(height: 16),
                _CourseInfoCardGrades(course: course),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseInfoCardGrades extends StatelessWidget {
  const _CourseInfoCardGrades({
    Key? key,
    required this.course,
  }) : super(key: key);

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    final gradeStyle = Theme.of(context).textTheme.labelMedium;
    final labelStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 75,
          child: Column(
            children: [
              Text(course.und1Grade, style: gradeStyle),
              Text('Unid. I', style: labelStyle)
            ],
          ),
        ),
        SizedBox(
          width: 75,
          child: Column(
            children: [
              Text(course.und2Grade, style: gradeStyle),
              Text('Unid. II', style: labelStyle)
            ],
          ),
        ),
        SizedBox(
          width: 75,
          child: Column(
            children: [
              Text(course.finalTest, style: gradeStyle),
              Text('Prova Final', style: labelStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _CourseInfoCardSchedule extends StatelessWidget {
  const _CourseInfoCardSchedule({Key? key, required this.course})
      : super(key: key);

  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    final place = Theme.of(context).textTheme.labelMedium;
    final date = Theme.of(context).textTheme.bodySmall;

    final width = Modular.get<ResponsiveSize>().w(context) / 3;

    if (course.schedule.isEmpty) {
      return const Center(
        child: Text(
          'Sem Horário',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    } else {
      return Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: course.schedule
              .map(
                (s) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          s.local.toUpperCase(),
                          style: place,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${s.day.substring(0, 3)} ${s.time}',
                          style: date,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
  }
}

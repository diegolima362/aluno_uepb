import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/extensions/courses_extensions.dart';

class CourseHomeCard extends StatelessWidget {
  final CourseEntity course;
  final int weekDay;
  final VoidCallback? onTap;
  final VoidCallback? onAddAlert;
  final bool showCurrentClass;

  const CourseHomeCard({
    Key? key,
    required this.course,
    required this.weekDay,
    this.onTap,
    this.onAddAlert,
    this.showCurrentClass = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().hour;
    final classTime =
        int.tryParse(course.schedule.first.time.split(':').first) ?? 0;

    final isCurrentClass = now >= classTime && now < classTime + 2;
    final active = showCurrentClass && isCurrentClass;

    final theme = Theme.of(context);

    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course.name, style: textTheme.bodyLarge),
                        Text(course.professor, style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: active,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.timelapse,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(course.schedule.first.local,
                      style: textTheme.labelMedium),
                  InputChip(
                    tooltip: 'Adicionar alerta',
                    label: Text(course.scheduleAtDay(weekDay).time),
                    onPressed: onAddAlert,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

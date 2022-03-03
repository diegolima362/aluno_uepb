import 'package:aluno_uepb/app/modules/courses/domain/extensions/courses_extensions.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final int weekDay;
  final VoidCallback? onTap;
  final bool showCurrentClass;

  const CourseCard({
    Key? key,
    required this.course,
    required this.weekDay,
    this.onTap,
    this.showCurrentClass = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(course.name,
                  maxLines: 2, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 8),
              Text(course.professor,
                  style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 16),
              if (course.schedule.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.scheduleAtDay(weekDay).local,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    InputChip(
                      label: Text(course.scheduleAtDay(weekDay).time),
                      onSelected: (_) {},
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

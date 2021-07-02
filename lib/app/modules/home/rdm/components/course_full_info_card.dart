import 'package:aluno_uepb/app/modules/home/rdm/components/course_info_card_header.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

import 'course_info_card_chart.dart';
import 'course_info_card_grades.dart';
import 'course_info_card_schedule.dart';

class CourseFullInfoCard extends StatelessWidget {
  final BuildContext context;
  final CourseModel course;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double elevation;
  final bool showChart;

  const CourseFullInfoCard({
    Key? key,
    required this.course,
    required this.context,
    this.onTap,
    this.color,
    this.elevation: 2.0,
    this.showChart: true,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: elevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              CourseInfoCardHeader(course: course),
              CourseInfoCardChart(course: course),
              const SizedBox(height: 10.0),
              CourseInfoCardSchedule(course: course),
              const SizedBox(height: 20.0),
              CourseInforCardGrades(course: course),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

class CourseInforCardGrades extends StatelessWidget {
  const CourseInforCardGrades({
    Key? key,
    required this.course,
  }) : super(key: key);

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.und1Grade}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Und. I',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.und2Grade}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Und. II',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        Container(
          width: 75,
          child: Column(
            children: [
              Text(
                '${course.finalTest}',
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
              ),
              Text(
                'Prova Final',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

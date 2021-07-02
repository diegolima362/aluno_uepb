import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

class CourseInfoCardSchedule extends StatelessWidget {
  static Map<int, String> _days = {
    1: 'Segunda',
    2: 'Terça',
    3: 'Quarta',
    4: 'Quinta',
    5: 'Sexta',
  };

  const CourseInfoCardSchedule({Key? key, required this.course})
      : super(key: key);

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: course.schedule
          .map(
            (s) => Container(
              child: Column(
                children: [
                  Text(
                    '${_days[s.weekDay]} ${s.time}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${s.local}',
                    style: TextStyle(
                      fontSize: 12,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

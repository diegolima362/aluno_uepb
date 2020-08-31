import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/course_info/course_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../course_info_card.dart';

final _weekDaysMap = {
  1: 'Segunda-feira',
  2: 'Terça-feira',
  3: 'Quarta-feira',
  4: 'Quinta-feira',
  5: 'Sexta-feira',
};

class WeekDayScheduleCard extends StatelessWidget {
  final WeekDaySchedule schedule;
  final VoidCallback onTap;
  final int weekDay;

  const WeekDayScheduleCard({
    Key key,
    @required this.schedule,
    @required this.onTap,
    @required this.weekDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courses = this.schedule.courses;
    final scheduleCards = List<CourseInfoCard>();

    courses.forEach(
      (e) => scheduleCards.add(
        CourseInfoCard(
          course: e,
          weekDay: weekDay,
          onTap: () => CourseInfoPage.show(
            context: context,
            course: e,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.0),
        Text(
          '${_weekDaysMap[weekDay]}',
          style: TextStyle(
              fontSize: 20.0,
              color: CustomThemes.accentColor,
              fontWeight: FontWeight.w500),
        ),
        ...scheduleCards,
      ],
    );
  }
}

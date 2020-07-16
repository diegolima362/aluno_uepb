import 'package:cau3pb/app/home/course_info_card.dart';
import 'package:cau3pb/models/week_day_schedule.dart';
import 'package:flutter/material.dart';

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
        CourseInfoCard(course: e, weekDay: weekDay),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.0),
        Text(
          '${_weekDaysMap[weekDay]}',
          style: TextStyle(fontSize: 20.0),
        ),
        ...scheduleCards,
      ],
    );
  }
}

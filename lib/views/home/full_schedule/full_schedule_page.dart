import 'dart:async';

import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'week_day_schedule_card.dart';

class FullSchedulePage extends StatelessWidget {
  final _adUnitID = 'ca-app-pub-5662469668063693/7852562025';

  List<Course> _buildWeekDaySchedule(List<Course> courses, int weekDay) {
    final todayClasses = List<Course>();

    courses.forEach((element) {
      final days = element.schedule.map((e) => e.weekDay).toList();
      final contains = days.indexOf(weekDay);
      if (contains != -1) todayClasses.add(element);
    });

    todayClasses.sort((a, b) =>
        a.startTimeAtDay(weekDay).compareTo(b.startTimeAtDay(weekDay)));

    return todayClasses;
  }

  Future<List<WeekDaySchedule>> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: true);
    List<Course> courses;

    try {
      courses = await database.getCoursesData();
    } on PlatformException catch (e) {
      throw PlatformException(
          code: 'error_get_courses_data', message: e.message);
    }

    final schedule = List<WeekDaySchedule>();

    for (int i = 1; i <= 5; i++) {
      schedule.add(WeekDaySchedule(
          courses: _buildWeekDaySchedule(courses, i), weekDay: i));
    }

    return schedule;
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<List<WeekDaySchedule>>(
      future: _getData(context),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          itemBuilder: (context, schedule) => WeekDayScheduleCard(
            schedule: schedule,
            onTap: () {},
            weekDay: schedule.weekDay,
          ),
          snapshot: snapshot,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildContent(context),
    );
  }
}

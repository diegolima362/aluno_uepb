import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

import 'widgets.dart';

final weekDaysMap = {
  1: 'Segunda-feira',
  2: 'Terça-feira',
  3: 'Quarta-feira',
  4: 'Quinta-feira',
  5: 'Sexta-feira',
};

class WeekDayScheduleCard extends StatelessWidget {
  final double? width;
  final double? height;
  final int weekDay;
  final List<CourseModel> courses;
  final bool showCurrentClass;

  const WeekDayScheduleCard({
    Key? key,
    this.width,
    this.height,
    required this.weekDay,
    required this.courses,
    this.showCurrentClass: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = width ?? MediaQuery.of(context).size.width;
    final _height = height ?? MediaQuery.of(context).size.height;
    final _portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final _courses = courses
        .map((c) => CourseInfoCard(
              course: c,
              weekDay: weekDay,
              showCurrentClass: showCurrentClass,
            ))
        .toList();

    return Container(
      width: _width * (_portrait ? 1 : .5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            weekDaysMap[weekDay]!,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 5),
          Container(
            height: _height * (_portrait ? .70 : .50),
            child: SingleChildScrollView(
              child: courses.isEmpty
                  ? Card(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      color: Theme.of(context).cardColor,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        height: 150,
                        child: Center(
                          child: Text(
                            'Sem aulas nesse dia',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _courses,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

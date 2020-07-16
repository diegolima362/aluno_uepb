import 'package:cau3pb/app/home/course_info_card.dart';
import 'package:cau3pb/app/home/full_schedule/full_schedule_page.dart';
import 'package:cau3pb/app/home/list_items_builder.dart';
import 'package:cau3pb/models/course.dart';
import 'package:cau3pb/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodaySchedulePage extends StatelessWidget {
  Future<List<Course>> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: true);
    List<Course> courses;

    try {
      courses = await database.getCoursesData();
    } on PlatformException catch (e) {
      throw PlatformException(
          code: 'error_get_courses_data', message: e.message);
    }

    return courses;
  }

  List<Course> _todayClassesList(List<Course> items) {
    final todayClasses = List<Course>();
    final weekday = DateTime.now().weekday;

    items.forEach((element) {
      final days = element.schedule.map((e) => e.weekDay).toList();
      final contains = days.indexOf(weekday);
      if (contains != -1) todayClasses.add(element);
    });

    todayClasses.sort((a, b) =>
        a.startTimeAtDay(weekday).compareTo(b.startTimeAtDay(weekday)));

    return todayClasses;
  }

  void _print(BuildContext context, Course course) {
    print(course);
  }

  Widget _buildHeader(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.0, top: 20.0),
      title: Text('Aulas de Hoje', style: TextStyle(fontSize: 32.0)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMEd', 'pt_Br').format(DateTime.now()),
            style: TextStyle(fontSize: 16.0),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: false,
                builder: (context) => FullSchedulePage(),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Horário completo',
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.end,
                ),
                Icon(Icons.arrow_forward_ios, size: 14.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        Expanded(
          child: FutureBuilder<List<Course>>(
            future: _getData(context),
            builder: (context, snapshot) {
              return ListItemsBuilder(
                itemBuilder: (context, course) => CourseInfoCard(
                  course: course,
                  weekDay: DateTime.now().weekday,
                  onTap: () => _print(context, course),
                ),
                filter: _todayClassesList,
                snapshot: snapshot,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContents(context),
      ),
    );
  }
}

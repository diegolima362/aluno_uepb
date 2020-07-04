import 'package:erdm/models/course.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseListCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseListCard({
    Key key,
    @required this.course,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentHour = DateFormat('Hm').format(now);
    final courseSchedule = course.scheduleAtDay(now.weekday);

    final _bgColor = currentHour.compareTo(courseSchedule.time) < 0
        ? Color(0xFFEEEEEEEE)
        : Colors.amberAccent;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: _bgColor,
        elevation: 0,
        child: Container(
          height: MediaQuery.of(context).size.width / 4.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  course.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF3E206D),
                  ),
                ),
                Text(
                  course.instructor.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF000000),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.scheduleAtDay(now.weekday)?.local ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10.0,
                      ),
                    ),
                    Text(
                      course.scheduleAtDay(now.weekday)?.time ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

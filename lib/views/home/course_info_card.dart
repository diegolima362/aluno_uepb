import 'package:cau3pb/models/models.dart';
import 'package:cau3pb/themes/custom_themes.dart';
import 'package:flutter/material.dart';

class CourseInfoCard extends StatelessWidget {
  final Course course;
  final int weekDay;
  final VoidCallback onTap;

  const CourseInfoCard({
    Key key,
    @required this.course,
    @required this.weekDay,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  course.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: CustomThemes.accentColor,
                  ),
                ),
                subtitle: Text(
                  course.professor.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                trailing: course.isCurrentClass
                    ? Icon(Icons.timer, color: CustomThemes.accentColor)
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.scheduleAtDay(weekDay)?.local ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10.0,
                    ),
                  ),
                  Text(
                    course.scheduleAtDay(weekDay)?.time ?? '',
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
    );
  }
}

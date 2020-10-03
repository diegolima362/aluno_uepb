import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
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
                  course.title,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: course.isCurrentClass ? FontWeight.bold : null,
                    fontSize: 16.0,
                    color:
                        course.isCurrentClass ? CustomThemes.accentColor : null,
                  ),
                ),
                subtitle: Text(
                  course.professor,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                trailing: course.isCurrentClass
                    ? Icon(Icons.timer_sharp, color: CustomThemes.accentColor)
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    course.scheduleAtDay(weekDay)?.local ?? '',
                    style: TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    course.scheduleAtDay(weekDay)?.time ?? '',
                    style: TextStyle(
                      fontSize: 12.0,
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

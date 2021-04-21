import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

class CourseInfoCard extends StatelessWidget {
  final CourseModel course;
  final int weekDay;
  final VoidCallback? onTap;
  final bool showCurrentClass;

  const CourseInfoCard({
    Key? key,
    required this.course,
    required this.weekDay,
    this.onTap,
    this.showCurrentClass: true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;
    final textColor = Theme.of(context).textTheme.headline6!.color;
    final isCurrentClass = course.isCurrentClass(weekDay);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  course.name,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: isCurrentClass && showCurrentClass
                        ? FontWeight.bold
                        : null,
                    color: isCurrentClass ? accent : textColor,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  course.professor,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                trailing: isCurrentClass && showCurrentClass
                    ? Icon(
                        Icons.timer_sharp,
                        color: accent,
                      )
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

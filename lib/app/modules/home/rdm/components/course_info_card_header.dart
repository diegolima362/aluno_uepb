import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

class CourseInfoCardHeader extends StatelessWidget {
  final CourseModel course;

  const CourseInfoCardHeader({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;

    return Container(
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              course.name.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: course.name.length > 30 ? 16.0 : 18.0,
              ),
            ),
            subtitle: Text(
              course.professor.toUpperCase(),
              style: TextStyle(
                fontSize: course.professor.length > 20 ? 15.0 : 16.0,
                color: accent,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'Carga Horária: ',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                '${course.ch}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

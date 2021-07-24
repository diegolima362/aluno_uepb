import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'course_picker.dart';

class CoursePickerDialog extends StatelessWidget {
  final List<CourseModel> courses;
  final void Function(CourseModel) onTap;
  final CourseModel initialCourse;

  const CoursePickerDialog({
    Key? key,
    required this.courses,
    required this.onTap,
    required this.initialCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 200,
        width: 120,
        child: CoursePicker(
          courses: courses,
          selectedCourse: initialCourse,
          onTap: onTap,
        ),
      ),
    );
  }
}

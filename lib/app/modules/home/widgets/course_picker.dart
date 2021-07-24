import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoursePicker extends StatefulWidget {
  final List<CourseModel> courses;
  final CourseModel selectedCourse;
  final void Function(CourseModel)? onTap;

  const CoursePicker({
    Key? key,
    required this.courses,
    required this.selectedCourse,
    this.onTap,
  }) : super(key: key);

  @override
  _CoursePickerState createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  late CourseModel selectedCourse;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedCourse = widget.selectedCourse;
    selectedIndex = widget.courses.indexOf(
      widget.courses.firstWhere((e) => e.id == selectedCourse.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.courses.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          return TextButton(
            onPressed: () => selectCourse(index),
            child: Text(
              widget.courses[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: index == selectedIndex
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              ),
            ),
          );
        },
      ),
    );
  }

  void selectCourse(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (widget.onTap != null) {
      widget.onTap!(widget.courses[index]);
    }
  }
}

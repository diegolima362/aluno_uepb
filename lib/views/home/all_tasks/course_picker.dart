import 'package:aluno_uepb/models/models.dart';
import 'package:flutter/material.dart';

class CoursePicker extends StatefulWidget {
  final ValueChanged<Course> selectCourse;
  final List<Course> courses;

  CoursePicker({Key key, this.selectCourse, this.courses}) : super(key: key);

  @override
  _CoursePickerState createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  Course _dropdownValue;
  List<Course> _courses;

  @override
  void initState() {
    _courses = widget.courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        const Text('Disciplina', style: TextStyle(fontSize: 20.0)),
        Expanded(child: const SizedBox()),
        Container(
          width: width * .6,
          child: DropdownButton<Course>(
            itemHeight: 70,
            elevation: 2,
            isExpanded: true,
            value: _dropdownValue,
            hint: Text('Escolher'),
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (course) => setState(() => _dropdownValue = course),
            items: _courses.map<DropdownMenuItem<Course>>((value) {
              return DropdownMenuItem<Course>(
                value: value,
                onTap: () => widget.selectCourse(value),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 0,
                  ),
                  child: Text(
                    value.title ?? '',
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

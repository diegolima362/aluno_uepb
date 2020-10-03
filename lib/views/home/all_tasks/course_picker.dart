import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoursePicker extends StatefulWidget {
  final ValueChanged<Course> selectCourse;
  final List<Course> courses;

  CoursePicker({Key key, this.selectCourse, this.courses}) : super(key: key);

  @override
  _CoursePickerState createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  List<Course> _courses;
  int _selectedIndex = 0;

  @override
  void initState() {
    _courses = widget.courses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        child: Row(
          children: [
            Text(
              'Curso: ',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: Text(
                _courses[_selectedIndex].capitalTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 100,
              child: CupertinoPicker(
                backgroundColor: Theme.of(context).cardTheme.color,
                looping: true,
                onSelectedItemChanged: (index) => setState(() {
                  widget.selectCourse(_courses[index]);
                  _selectedIndex = index;
                }),
                itemExtent: 70,
                children: List<Widget>.generate(
                  _courses.length,
                  (int index) {
                    return Center(
                      child: Text(
                        _courses[index].capitalTitle,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CustomThemes.isDark
                                ? Colors.white
                                : Colors.black),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/*
* Container(
          width: width * .6,
          child: DropdownButton<Course>(
            itemHeight: 70,
            elevation: 2,
            isExpanded: true,
            value: _dropdownValue,
            dropdownColor: Theme.of(context).cardTheme.color,
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
        ),*/

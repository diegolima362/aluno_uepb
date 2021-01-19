import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';

class CoursePicker extends StatefulWidget {
  final ValueChanged<CourseModel> selectCourse;
  final List<CourseModel> courses;
  final Color bgColor;
  final Color highlightColor;
  final double height;
  final double width;

  CoursePicker({
    Key key,
    this.selectCourse,
    this.courses,
    this.bgColor,
    this.highlightColor,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _CoursePickerState createState() => _CoursePickerState();
}

class _CoursePickerState extends State<CoursePicker> {
  List<CourseModel> _courses;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final dark = Theme.of(context).brightness == Brightness.dark;

    final size = MediaQuery.of(context).size;
    final h = widget.height ?? size.height * 0.15;
    // final bg = widget.bgColor ?? dark ? Colors.black : Colors.white;
    // final w = widget.width ?? size.width;

    return GestureDetector(
      onTap: _showPicker,
      child: Container(
        height: h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Curso: ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                Format.capitalString(_courses[_selectedIndex].name),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _courses = widget.courses;
    _courses.sort((a, b) => a.name.compareTo(b.name));

    super.initState();
  }

  void _setCourse(int value) => setState(() {
        widget.selectCourse(_courses[value]);
        return _selectedIndex = value;
      });

  Future<void> _showPicker() async {
    final accent = Theme.of(context).accentColor;

    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final size = MediaQuery.of(context).size;
    final h = widget.height ?? size.height * 0.5;
    final w = size.width * .9;

    await showDialog(
      context: context,
      builder: (context) {
        int _tempIndex = _selectedIndex;

        return StatefulBuilder(
          builder: (context, innerSetState) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              actionsPadding: EdgeInsets.zero,
              title: Text(
                'Escolher curso',
                style: TextStyle(color: accent, fontSize: 20),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    _setCourse(_tempIndex);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: SingleChildScrollView(
                child: Container(
                  height: h,
                  width: w * (portrait ? 1 : .5),
                  child: Container(
                    height: h * (portrait ? .7 : .5),
                    child: ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final c = _courses[index];
                        return ListTile(
                          onTap: () => innerSetState(() => _tempIndex = index),
                          title: Text(
                            Format.capitalString(c.name),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _tempIndex == index
                                  ? accent
                                  : Theme.of(context).disabledColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

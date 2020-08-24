import 'dart:ui';

import 'package:cau3pb/models/models.dart';
import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/themes/custom_themes.dart';
import 'package:cau3pb/views/home/all_tasks/edit_task_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskInfoPage extends StatelessWidget {
  final Task task;
  final Database database;

  const TaskInfoPage({Key key, this.task, this.database}) : super(key: key);

  static Future<void> show(BuildContext context, Task task) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => TaskInfoPage(database: database, task: task),
      ),
    );
  }

  Future<void> _editTask(BuildContext context) async {
    final courses = await database.getCoursesData();
    final course = courses.firstWhere((e) => e.id == task.courseId);

    EditTaskPage.show(
      context: context,
      database: database,
      course: course,
      task: task,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        elevation: 0,
        actions: [
          FlatButton(
            disabledTextColor: Theme.of(context).appBarTheme.color,
            textColor: CustomThemes.accentColor,
            child: Text('Editar', style: TextStyle(fontSize: 20.0)),
            onPressed: () => _editTask(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  task.title,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: CustomThemes.accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  task.courseTitle,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
                if (task.comment.isNotEmpty) const SizedBox(height: 100),
                Text(task.comment, style: TextStyle(fontSize: 18.0)),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Format.date(task.date),
                      style: TextStyle(fontSize: 16.0)
                    ),
                    Text(
                      Format.hours(task.date),
                      style: TextStyle(fontSize: 16.0),
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

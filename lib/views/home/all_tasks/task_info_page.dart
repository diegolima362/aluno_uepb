import 'dart:ui';

import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/all_tasks/edit_task_page.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskInfoPage extends StatelessWidget {
  final Task task;
  final Database database;
  final NotificationsService notificationsService;

  const TaskInfoPage({
    Key key,
    this.task,
    this.database,
    this.notificationsService,
  }) : super(key: key);

  static Future<void> show({
    @required BuildContext context,
    Task task,
    @required NotificationsService notificationsService,
    @required Database database,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => TaskInfoPage(
          database: database,
          task: task,
          notificationsService: notificationsService,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Remover Tarefa',
      content: 'Tem certeza que quer Remover?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Remover',
    ).show(context);

    if (didRequestSignOut == true) {
      await _deleteTask(context);
    }
  }

  Future<void> _deleteTask(BuildContext context) async {
    try {
      await database.deleteTask(task);
      await notificationsService.cancelNotification(int.parse(task.id));
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação falhou',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _markTaskAsDone(BuildContext context) async {
    try {
      task.isCompleted = true;
      await database.addTask(task);
      await notificationsService.cancelNotification(int.parse(task.id));
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação falhou',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _editTask(BuildContext context) async {
    final courses = await database.getCoursesData();
    final course = courses.firstWhere((e) => e.id == task.courseId);

    EditTaskPage.show(
      context: context,
      database: database,
      course: course,
      task: task,
      notificationsService: notificationsService,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        elevation: 0,
        actions: [
          if (!task.isCompleted)
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () => _markTaskAsDone(context),
            ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editTask(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(10),
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
                    Text(Format.date(task.date),
                        style: TextStyle(fontSize: 16.0)),
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

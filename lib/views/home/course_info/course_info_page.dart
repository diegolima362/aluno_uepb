import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/all_courses/course_full_info_card.dart';
import 'package:aluno_uepb/views/home/all_tasks/all_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'course_active_reminders.dart';
import 'course_scheduler.dart';

class CourseInfoPage extends StatelessWidget {
  final Course course;
  final Database database;
  final NotificationsService notificationsService;

  const CourseInfoPage({
    Key key,
    this.course,
    this.database,
    this.notificationsService,
  }) : super(key: key);

  static Future<void> show({
    @required BuildContext context,
    Course course,
  }) async {
    final notificationsService =
        Provider.of<NotificationsService>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CourseInfoPage(
          database: database,
          course: course,
          notificationsService: notificationsService,
        ),
      ),
    );
  }

  Future<List<Task>> _getTasksData(BuildContext context) async {
    List<Task> tasks;

    try {
      tasks = await database.getTasksData();
    } on PlatformException catch (e) {
      throw PlatformException(code: 'error_get_tasks_data', message: e.message);
    }
    tasks = tasks.where((e) => e.courseId == course.id).toList();
    tasks.sort((a, b) => a.date.compareTo(b.date));
    return tasks;
  }

  Future<void> _addReminder(BuildContext context) async {
    CourseScheduler.show(
      context: context,
      database: database,
      course: course,
      notificationsService: notificationsService,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        elevation: 0,
        actions: [
          FlatButton(
            onPressed: () => _addReminder(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Novo Alerta',
                  style: TextStyle(
                    fontSize: 16,
                    color: CustomThemes.accentColor,
                  ),
                ),
                Icon(
                  Icons.add,
                  color: CustomThemes.accentColor,
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CourseFullInfoCard(
              course: course,
              customCardColor: Theme.of(context).canvasColor,
              customElevation: 0,
            ),
            const SizedBox(height: 40),
            Text(
              'Alertas',
              style: TextStyle(
                color: CustomThemes.accentColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: _height * .2,
              child: CourseActiveReminders(
                notificationsService: notificationsService,
                course: course,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Atividades',
              style: TextStyle(
                color: CustomThemes.accentColor,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: _height * .2,
              child: _buildTasks(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _getTasksData(context),
      builder: (context, snapshot) => ListItemsBuilder(
        emptyWidget: Text('Sem atividades agendadas'),
        snapshot: snapshot,
        itemBuilder: (context, task) => TaskInfoCard(
          task: task,
          onTap: () => TaskInfoPage.show(
            context: context,
            task: task,
            database: database,
            notificationsService: notificationsService,
          ),
        ),
      ),
    );
  }
}

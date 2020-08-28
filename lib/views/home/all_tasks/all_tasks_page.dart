import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/all_tasks/task_info_card.dart';
import 'package:aluno_uepb/views/home/all_tasks/task_info_page.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../list_items_builder.dart';
import 'edit_task_page.dart';

class AllTasksPage extends StatefulWidget {
  @override
  _AllTasksPageState createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  bool isLoading = false;

  Future<List<Task>> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    List<Task> tasks;

    try {
      tasks = await database.getTasksData();
    } on PlatformException catch (e) {
      throw PlatformException(code: 'error_get_tasks_data', message: e.message);
    }

    tasks.sort((a, b) => a.date.compareTo(b.date));
    return tasks;
  }

  void _addTask(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    EditTaskPage.show(context: context, database: database);
  }

  Future<void> _delete(BuildContext context, Task task) async {
    setState(() => isLoading = true);
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteTask(task);
      setState(() => isLoading = false);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação falhou',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _markAsDone(BuildContext context, Task task) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      task.isCompleted = true;
      await database.addTask(task);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação falhou',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Atividades',
          style: TextStyle(color: CustomThemes.accentColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: CustomThemes.accentColor),
            onPressed: () => _addTask(context),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    if (isLoading) return Center(child: CircularProgressIndicator());
    return ValueListenableBuilder<Box>(
      valueListenable: database.onTasksChanged(),
      builder: (context, box, child) {
        return FutureBuilder<List<Task>>(
          future: _getData(context),
          builder: (context, snapshot) => ListItemsBuilder(
            emptyMessage: 'Você não tem atividades agendadas',
            snapshot: snapshot,
            itemBuilder: (context, task) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: CustomThemes.accentColor,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(right: 16.0),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, task),
              child: TaskInfoCard(
                task: task,
                onTap: () => TaskInfoPage.show(context, task),
                onLongPress: () => _markAsDone(context, task),
              ),
            ),
          ),
        );
      },
    );
  }
}
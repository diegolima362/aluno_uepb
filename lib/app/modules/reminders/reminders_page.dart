import 'package:aluno_uepb/app/modules/reminders/tasks/components/task_info_card.dart';
import 'package:aluno_uepb/app/shared/components/custom_fab.dart';
import 'package:aluno_uepb/app/shared/components/custom_scaffold.dart';
import 'package:aluno_uepb/app/shared/components/empty_content.dart';
import 'package:aluno_uepb/app/shared/models/task_model.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'reminders_controller.dart';
import 'sort_by.dart';

class RemindersPage extends StatefulWidget {
  final String title;

  const RemindersPage({Key key, this.title = "Lembretes"}) : super(key: key);

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState
    extends ModularState<RemindersPage, RemindersController> {
  // use 'controller' variable to access controller

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return CustomScaffold(
        actions: [
          if ((controller.hasTasks || controller.hasCompletedTasks)) ...[
            _buildPopupMenuButton(),
            IconButton(
              tooltip: 'Apagar lembretes',
              icon: Icon(
                controller.deleteMode ? Icons.cancel_outlined : Icons.delete,
              ),
              onPressed: controller.setDeleteMode,
            ),
          ]
        ],
        textTitle: 'Lembretes',
        body: Observer(builder: (_) => _buildContent()),
        scrollController: _scrollController,
        floatingActionButton: Observer(builder: (_) => _buildFAB()),
      );
    });
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton<SortBy>(
      icon: Icon(Icons.sort_sharp),
      onSelected: (value) => controller.sortBy(value),
      itemBuilder: (BuildContext context) {
        final choices = ['Título', 'Curso', 'Data'];
        return choices.map((String choice) {
          return PopupMenuItem<SortBy>(
            value: SortBy.values[choices.indexOf(choice)],
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _handleScroll();
  }

  Future<void> _addTask() async {
    if (!controller.hasCourses) {
      _showSnackBar('Sem cursos registrados');
    } else {
      await controller.addTask();
    }
  }

  Widget _buildContent() {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (controller.tasks.isEmpty && controller.completedTasks.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Sem lembretes registrados',
      );
    } else {
      int _tasks = controller.tasks.length;
      final _completed = controller.completedTasks.length;
      final accent = Theme.of(context).accentColor;

      int _length = (_tasks == 0 ? 1 : _tasks) +
          (_completed == 0 ? 0 : _completed + 1) +
          1;

      return ListView.builder(
        itemCount: _length,
        itemBuilder: (context, index) {
          if (controller.hasTasksToDelete) index--;

          if (_tasks == 0 && index == 0)
            return Column(
              children: [
                Divider(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 50,
                  child: Center(
                    child: Text(
                      'Sem lembretes futuros',
                      style: TextStyle(
                        fontSize: 24,
                        color: accent,
                      ),
                    ),
                  ),
                ),
                Divider(height: 10),
              ],
            );
          else if (index == _length - 1)
            return Container(height: 75);
          else if (_tasks == 0 && index == 1 || _tasks != 0 && index == _tasks)
            return Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 50,
              child: Center(
                  child: Text(
                'Lembretes passados',
                style: TextStyle(
                  fontSize: 24,
                  color: accent,
                ),
              )),
            );

          TaskModel task;

          if (index < _tasks) {
            task = controller.tasks[index];
          } else {
            task = controller
                .completedTasks[index - (_tasks == 0 ? 1 : _tasks) - 1];
          }

          return Observer(builder: (_) {
            Function onTap;

            bool marked = controller.deleteList?.contains(task) ?? false;

            if (controller.deleteMode) {
              onTap = () => marked
                  ? controller.removeFromDeleteList(task)
                  : controller.addToDelete(task);
            } else {
              onTap = () async => await controller.showDetails(task);
            }

            return TaskInfoCard(
              task: task,
              onLongPress:
                  controller.deleteMode ? null : () => _showDialog(task),
              marked: marked,
              deleteMode: controller.deleteMode,
              onTap: onTap,
            );
          });
        },
      );
    }
  }

  Widget _buildFAB() {
    bool extended = controller.extended;
    String toolTipText;
    String labelText;
    Function onPressed;
    Icon icon;

    if (controller.deleteMode) {
      toolTipText = 'Apagar Lembretes';
      labelText = 'Apagar';
      onPressed = controller.hasTasksToDelete
          ? () async {
              final text = 'Apagando ${controller.deleteList.length} items';
              await controller.deleteItems();
              _showSnackBar(text);
            }
          : () {};
      icon = Icon(Icons.delete);
    } else {
      toolTipText = 'Adicionar Lembrete';
      labelText = 'Adicionar';
      onPressed = _addTask;
      icon = Icon(Icons.add);
    }

    return CustomFAB(
      onPressed: () async => await onPressed(),
      tooltip: toolTipText,
      label: labelText,
      extended: extended,
      icon: icon,
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<SortBy>(
      icon: Icon(Icons.sort_sharp),
      tooltip: 'Ordenar',
      onSelected: controller.sortBy,
      itemBuilder: (BuildContext context) {
        final choices = ['Curso', 'Data', 'Título'];
        return choices.map((choice) {
          return PopupMenuItem<SortBy>(
            value: SortBy.values[choices.indexOf(choice)],
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void _handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        controller.setExtended(false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        controller.setExtended(true);
      }
    });
  }

  void _showDialog(TaskModel task) {
    asuka.showDialog(
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () async {
                  await controller.delete(task);
                  Modular.to.pop();
                },
                child: Text('Apagar'),
              ),
              Divider(height: 0),
              TextButton(
                onPressed: () async {
                  await controller.edit(task);
                  Modular.to.pop();
                },
                child: Text('Editar'),
              ),
              Divider(height: 0),
              TextButton(
                onPressed: () async {
                  await controller.markAsDone(task);
                  Modular.to.pop();
                },
                child: Text(
                  task.isCompleted
                      ? 'Marcar como não concluído'
                      : 'Marcar como concluído',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).backgroundColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).accentColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

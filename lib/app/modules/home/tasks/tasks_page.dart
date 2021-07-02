import 'dart:math' as math;

import 'package:aluno_uepb/app/modules/home/routes.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'tasks_controller.dart';

class TasksPage extends StatefulWidget {
  final String title;

  const TasksPage({Key? key, this.title = "Lembretes"}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ModularState<TasksPage, TasksController> {
  // use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return CustomScaffold(
        actions: [
          if ((controller.hasTasks || controller.hasCompletedTasks)) ...[
            IconButton(
              tooltip: 'Apagar lembretes',
              icon: Icon(
                controller.deleteMode ? Icons.cancel_outlined : Icons.delete,
                color: Theme.of(context).textTheme.caption!.color,
              ),
              onPressed: controller.toggleDeleteMode,
            ),
            _buildPopupMenuButton(),
          ]
        ],
        titleText: 'Lembretes',
        body: Observer(builder: (_) => _buildContent()),
        floatingActionButton: Observer(builder: (_) => _buildFAB()),
      );
    });
  }

  Widget buildPopupMenuButton() {
    return PopupMenuButton<SortBy>(
      icon: Icon(Icons.sort_sharp),
      onSelected: (value) => controller.sortTasks(value),
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

  Widget _buildContent() {
    if (controller.isLoading) {
      return LoadingIndicator(text: 'Carregando');
    } else if (controller.hasError) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Erro ao obter os dados',
      );
    } else if (controller.tasks.isEmpty && controller.completedTasks.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Sem lembretes registrados',
      );
    } else {
      int _tasks = controller.tasks.length;
      final _completed = controller.completedTasks.length;

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
                      style: TextStyle(fontSize: 24),
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
                style: TextStyle(fontSize: 24),
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
            VoidCallback onTap;

            bool marked = controller.deleteList.contains(task);

            if (controller.deleteMode) {
              onTap = () => marked
                  ? controller.removeFromDeleteList(task)
                  : controller.addToDelete(task);
            } else {
              onTap = () {
                Modular.to.pushNamed(TASKS_DETAILS, arguments: task);
              };
            }

            return TaskInfoCard(
              task: task,
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
      icon = Icon(Icons.add);
      onPressed = () {
        if (controller.hasCourses) {
          Modular.to.pushNamed(TASKS_EDIT);
        } else {
          _showSnackBar('Sem cursos registrados');
        }
      };
    }

    return CustomFAB(
      onPressed: () async => await onPressed(),
      tooltip: toolTipText,
      label: labelText,
      extended: true,
      icon: icon,
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<SortBy>(
      icon: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: Icon(
          Icons.sort,
          color: Theme.of(context).textTheme.caption!.color,
        ),
      ),
      tooltip: 'Ordenar',
      onSelected: controller.sortTasks,
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

  void _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).accentColor),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).cardTheme.color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

import 'package:aluno_uepb/app/modules/home/routes.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../tasks_controller.dart';
import 'tasks_details_controller.dart';

class TaskDetailsPage extends StatefulWidget {
  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState
    extends ModularState<TaskDetailsPage, TaskDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        actions: [
          Observer(builder: (_) {
            final done = controller.done;

            return IconButton(
              tooltip: done ? 'Marcar como não feito' : 'Marcar como feito',
              icon: Icon(
                done ? Icons.remove_done : Icons.done_all_outlined,
              ),
              onPressed: () async {
                await controller.setDone(!done);
                await (Modular.get<TasksController>().loadData());
              },
            );
          }),
          IconButton(
            tooltip: 'Editar lembrete',
            icon: Icon(Icons.edit),
            onPressed: () {
              Modular.to.popAndPushNamed(
                TASKS_EDIT,
                arguments: controller.task,
              );
            },
          ),
          IconButton(
            tooltip: 'Deletar lembrete',
            icon: Icon(Icons.delete),
            onPressed: () async {
              await controller.delete();
              await (Modular.get<TasksController>().loadData());
              Modular.to.navigate(TASKS_PAGE);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Observer(
            builder: (_) => TaskInfoCard(
              task: controller.task,
              extended: true,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:aluno_uepb/app/modules/reminders/tasks/components/task_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details_controller.dart';

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
              onPressed: () async => await controller.setDone(!done),
            );
          }),
          IconButton(
            tooltip: 'Editar lembrete',
            icon: Icon(Icons.edit),
            onPressed: controller.edit,
          ),
          IconButton(
            tooltip: 'Deletar lembrete',
            icon: Icon(Icons.delete),
            onPressed: controller.delete,
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

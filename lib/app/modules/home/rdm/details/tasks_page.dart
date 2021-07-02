import 'package:aluno_uepb/app/modules/home/rdm/details/rdm_details_controller.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../components/header.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends ModularState<TasksPage, RDMDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        var _length = controller.tasks.length;
        if (_length == 0) _length++; // if list empty, add empty indicator
        _length++; // add header

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4),
          itemCount: _length,
          itemBuilder: (context, index) {
            if (index == 0) return Header(title: 'Atividades');

            if (index == 1 && controller.tasks.length == 0)
              return Container(
                margin: EdgeInsets.all(8),
                height: 100,
                color: Theme.of(context).cardTheme.color,
                child: Center(
                  child: Text('Sem atividades registradas'),
                ),
              );

            final t = controller.tasks[index - 1];

            return TaskInfoCard(task: t, short: true);
          },
        );
      },
    );
  }
}

import 'package:aluno_uepb/app/modules/home/rdm/details/rdm_details_controller.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../routes.dart';
import '../components/header.dart';

class AlertsPage extends StatefulWidget {
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends ModularState<AlertsPage, RDMDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFAB(),
      body: Observer(
        builder: (_) {
          var _length = controller.reminders.length;
          if (_length == 0) _length++; // if list empty, add empty indicator
          _length++; // add header

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4),
            itemCount: _length,
            itemBuilder: (context, index) {
              if (index == 0) return Header(title: 'Alertas');

              if (index == 1 && controller.reminders.length == 0)
                return Container(
                  margin: EdgeInsets.all(8),
                  height: 100,
                  color: Theme.of(context).cardTheme.color,
                  child: Center(
                    child: Text('Sem alertas registrados'),
                  ),
                );

              final r = controller.reminders[index - 1];
              return NotificationInfoCard(
                notification: r,
                onDelete: () async => await controller.deleteReminder(r),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFAB() {
    return CustomFAB(
      tooltip: 'Adicionar alerta',
      label: 'Adicionar',
      extended: true,
      icon: Icon(Icons.add_alarm_outlined),
      onPressed: () => Modular.to.pushNamed(
        COURSE_SCHEDULER,
        arguments: controller.course,
      ),
    );
  }
}

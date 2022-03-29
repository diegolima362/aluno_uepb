import 'package:aluno_uepb/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/presenter/widgets/empty_collection.dart';
import '../../domain/entities/entities.dart';

import 'alerts_store.dart';
import 'recurring_alert_card.dart';

class AlertsPage extends StatefulWidget {
  final CourseEntity course;

  const AlertsPage({Key? key, required this.course}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ModularState<AlertsPage, RecurringAlertsStore> {
  bool visible = true;
  ScrollDirection lastOrientations = ScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    store.getData(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: visible ? 1 : 0,
        child: FloatingActionButton(
          tooltip: 'Adicionar alerta',
          child: const Icon(Icons.add_alarm_outlined),
          onPressed: () => Modular.to.pushNamed(
            '/root/alerts/recurring/edit/',
            arguments: {'course': widget.course.id},
            forRoot: true,
          ),
        ),
      ),
      body: ValueListenableBuilder<List<RecurringAlertEntity>>(
        valueListenable: store.selectState,
        builder: (context, state, _) {
          if (state.isEmpty) {
            return const EmptyCollection(
              text: 'Sem alertas registrados',
              icon: Icons.alarm_off_sharp,
            );
          }

          final count = state.length;

          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final direction = notification.direction;

              if (direction != lastOrientations) {
                setState(() {
                  lastOrientations = direction;
                  if (direction == ScrollDirection.reverse) {
                    visible = false;
                  } else if (direction == ScrollDirection.forward) {
                    visible = state.isNotEmpty;
                  }
                });
              }
              return true;
            },
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                final alert = state[index];

                return Padding(
                  padding:
                      EdgeInsets.only(bottom: index == count - 1 ? 100 : 0),
                  child: RecurringAlertCard(
                    alert: alert,
                    onEdit: () {
                      Modular.to.pushNamed(
                        '/root/alerts/recurring/edit/',
                        arguments: {'course': widget.course.id, 'alert': alert},
                        forRoot: true,
                      );
                    },
                    onRemove: () async {
                      await store.removeAlert(alert.id);
                      store.getData(widget.course.id);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

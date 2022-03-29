import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:aluno_uepb/app/modules/courses/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/errors/erros.dart';
import 'reminder_card.dart';
import 'reminders_store.dart';

class RemindersPage extends StatefulWidget {
  final CourseEntity? course;

  const RemindersPage({Key? key, this.course}) : super(key: key);

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends ModularState<RemindersPage, RemindersStore> {
  bool visible = true;
  ScrollDirection lastOrientations = ScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    store.getData(widget.course?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: visible ? 1 : 0,
        child: FloatingActionButton(
          tooltip: 'Adicionar atividade',
          child: const Icon(Icons.post_add_sharp),
          onPressed: () => Modular.to.pushNamed(
            '/root/alerts/reminder/edit/',
            arguments: {'course': widget.course?.id},
            forRoot: true,
          ),
        ),
      ),
      body: ScopedBuilder<RemindersStore, AlertFailure, Reminders>(
        store: store,
        onLoading: (_) => const Center(child: CircularProgressIndicator()),
        onError: (_, __) => EmptyCollection.error(),
        onState: (context, state) {
          if (state.isEmpty) {
            return const EmptyCollection(
              text: 'Sem lembretes registrados',
              icon: Icons.content_paste_off_sharp,
            );
          }

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
              itemCount: state.length,
              itemBuilder: (context, index) {
                final reminder = state[index];

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == state.length - 1 ? 100 : 0),
                  child: ReminderCard(
                    reminder: reminder,
                    onTap: () {
                      Modular.to.pushNamed(
                        '/root/alerts/reminder/details/',
                        arguments: reminder,
                        forRoot: true,
                      );
                    },
                    onEdit: () => Modular.to.pushNamed(
                      '/root/alerts/reminder/edit/',
                      arguments: {
                        'course': widget.course?.id ?? reminder.course,
                        'reminder': reminder,
                      },
                      forRoot: true,
                    ),
                    onRemove: () async {
                      await store.removeReminder(reminder.id);
                      store.getData(widget.course?.id);
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

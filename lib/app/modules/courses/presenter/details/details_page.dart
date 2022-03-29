import 'package:aluno_uepb/app/modules/alerts/presenter/alerts/alerts_page.dart';
import 'package:aluno_uepb/app/modules/alerts/presenter/reminders/reminders_page.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

class CourseDetailsPage extends StatelessWidget {
  final CourseEntity course;

  const CourseDetailsPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondaryContainer
              .withOpacity(0.25),
          toolbarHeight: 30,
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Alertas', style: textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Atividades', style: textTheme.titleLarge),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AlertsPage(course: course),
            RemindersPage(course: course),
          ],
        ),
      ),
    );
  }
}

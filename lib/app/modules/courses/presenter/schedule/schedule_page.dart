import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:aluno_uepb/app/modules/courses/domain/errors/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import 'schedule_store.dart';
import 'widgets/courses_card_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ModularState<SchedulePage, ScheduleStore> {
  @override
  void initState() {
    super.initState();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aulas da semana')),
      body: ScopedBuilder<ScheduleStore, RDMFailure, List<CourseEntity>>(
        store: store,
        onState: (context, state) {
          if (state.isEmpty) {
            return EmptyCollection.error();
          } else {
            return CoursesCardList(
              courses: state.where((c) => c.schedule.isNotEmpty).toList(),
            );
          }
        },
        onError: (context, error) => EmptyCollection.error(),
        onLoading: (context) => const LoadingIndicator(),
      ),
    );
  }
}

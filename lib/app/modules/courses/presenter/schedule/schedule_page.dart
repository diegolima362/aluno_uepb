import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import 'utils/generate_pdf.dart';
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
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      floatingActionButton: _PrintButton(valueListenable: store.selectState),
      body: ScopedBuilder<ScheduleStore, CoursesFailure, List<CourseEntity>>(
        store: store,
        onError: (context, error) => EmptyCollection.error(),
        onLoading: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        onState: (context, state) {
          if (state.isEmpty) {
            return const EmptyCollection(
              icon: Icons.schedule_sharp,
              text: 'Sem aulas registradas!',
            );
          } else {
            return CoursesCardList(
              courses: state.where((c) => c.schedule.isNotEmpty).toList(),
            );
          }
        },
      ),
    );
  }
}

class _PrintButton extends StatelessWidget {
  const _PrintButton({Key? key, required this.valueListenable})
      : super(key: key);

  final ValueListenable<List<CourseEntity>> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CourseEntity>>(
      valueListenable: valueListenable,
      builder: (context, courses, _) {
        return Visibility(
          visible: courses.isNotEmpty,
          child: FloatingActionButton(
            onPressed: () => generatePdf(courses),
            child: const Icon(Icons.print_outlined),
          ),
        );
      },
    );
  }
}

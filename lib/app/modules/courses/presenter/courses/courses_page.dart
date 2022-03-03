import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:aluno_uepb/app/modules/courses/domain/errors/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import 'courses_store.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ModularState<CoursesPage, CoursesStore> {
  @override
  void initState() {
    super.initState();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RDM'),
        actions: [
          IconButton(
            onPressed: store.updateData,
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: ScopedBuilder<CoursesStore, RDMFailure, List<CourseEntity>>(
        store: store,
        onState: (context, state) {
          if (state.isEmpty) {
            return EmptyCollection.error();
          } else {
            return ListView.builder(
              itemCount: state.length,
              itemBuilder: (context, index) {
                final course = state[index];
                return ListTile(
                  title: Text(course.name),
                  subtitle: Text(course.professor),
                );
              },
            );
          }
        },
        onError: (context, error) => EmptyCollection.error(),
        onLoading: (context) => const LoadingIndicator(),
      ),
    );
  }
}

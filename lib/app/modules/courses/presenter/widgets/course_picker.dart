import 'package:aluno_uepb/app/modules/courses/domain/usecases/get_courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/course_entity.dart';

class CoursePicker extends HookWidget {
  final void Function(CourseEntity?)? onSelect;

  const CoursePicker({Key? key, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(() => Modular.get<GetCourses>().call());
    final state = useFuture(future);

    final color = Theme.of(context).colorScheme.primary;

    final course = useState('Escolha um curso');

    if (state.hasError) return const Text('Erro ao carregar cursos');

    final data = state.data;

    if (data == null || data.isLeft()) return const Text('Carregando ...');

    final courses = data.getOrElse((l) => []);

    return Tooltip(
      message: 'Escolher curso',
      child: GestureDetector(
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(child: Text(course.value)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        onTap: () async {
          await showModalBottomSheet<CourseEntity>(
            context: context,
            backgroundColor: Colors.transparent,
            useRootNavigator: false,
            isScrollControlled: true,
            builder: (_) => OptionsModal<CourseEntity>(
              title: 'Escolha um curso',
              items: courses,
              onSelected: (c) {
                onSelect?.call(c);
                course.value = c.name;
              },
              itemBuilder: (c) => TextOption(
                c.name,
                textColor: c.name == course.value ? color : null,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }
}

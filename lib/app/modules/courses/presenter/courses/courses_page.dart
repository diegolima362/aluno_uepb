import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/errors/errors.dart';
import '../widgets/widgets.dart';
import 'courses_store.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends ModularState<CoursesPage, CoursesStore> {
  bool visible = true;
  ScrollDirection lastOrientations = ScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedBuilder<CoursesStore, CoursesFailure, List<CourseEntity>>(
        store: store,
        onError: (context, error) => EmptyCollection.error(),
        onLoading: (context) => const Center(child: Text('Carregando')),
        onState: (context, state) {
          if (state.isEmpty) {
            return const EmptyCollection(
              text: 'Sem cursos registrados',
              icon: Icons.library_books_outlined,
            );
          } else {
            final itemsTotal = state.length;
            return Scaffold(
              floatingActionButton: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: visible ? 1 : 0,
                child: FloatingActionButton(
                  child: const Icon(Icons.print_outlined),
                  onPressed: store.openRDM,
                ),
              ),
              body: NotificationListener<UserScrollNotification>(
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
                child: RefreshIndicator(
                  onRefresh: store.updateData,
                  semanticsLabel: 'Atualizar RDM',
                  child: ListView.builder(
                    itemCount: itemsTotal,
                    itemBuilder: (context, index) => CourseInfoCard(
                      course: state[index],
                      onTap: () => Modular.to.pushNamed(
                        '/root/courses/details/',
                        arguments: state[index],
                        forRoot: true,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

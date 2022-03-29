import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import '../widgets/widgets.dart';
import 'today_store.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ModularState<TodayPage, TodayStore> {
  bool visible = true;
  ScrollDirection lastOrientations = ScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return ScopedBuilder<TodayStore, CoursesFailure, List<CourseEntity>>(
      store: store,
      onError: (context, error) => EmptyCollection.error(),
      onLoading: (context) => const Center(child: Text('Carregando')),
      onState: (context, state) {
        final itemsTotal = state.length;
        return Scaffold(
          floatingActionButton: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: visible ? 1 : 0,
            child: FloatingActionButton(
              tooltip: 'Horários',
              child: const Icon(Icons.calendar_month_sharp),
              onPressed: () => Modular.to.pushNamed(
                '/root/courses/schedule/',
                forRoot: true,
              ),
            ),
          ),
          body: state.isEmpty
              ? const EmptyCollection(
                  text: 'Sem aulas hoje!',
                  icon: Icons.calendar_today_sharp,
                )
              : NotificationListener<UserScrollNotification>(
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
                    itemCount: itemsTotal,
                    itemBuilder: (context, index) {
                      return CourseHomeCard(
                        course: state[index],
                        weekDay: today.weekday,
                        onTap: () => Modular.to.pushNamed(
                          '/root/courses/details/',
                          arguments: state[index],
                          forRoot: true,
                        ),
                        onAddAlert: () => Modular.to.pushNamed(
                          '/root/alerts/recurring/edit/',
                          arguments: {'course': state[index].id},
                          forRoot: true,
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

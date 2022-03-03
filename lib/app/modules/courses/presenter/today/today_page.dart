import 'package:aluno_uepb/app/modules/courses/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/entities.dart';
import '../../domain/errors/errors.dart';
import 'today_store.dart';

import '../../../../core/domain/extensions/extensions.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ModularState<TodayPage, TodayStore> {
  @override
  void initState() {
    super.initState();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(today.dayOfWeek.capitalFirst),
            Text(
              today.fullDate,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Modular.to.pushNamed('/root/courses/schedule'),
            icon: const Text('Ver mais'),
            label: const Icon(Icons.keyboard_arrow_right_sharp),
          )
        ],
      ),
      body: ScopedBuilder<TodayStore, RDMFailure, List<CourseEntity>>(
        store: store,
        onError: (context, error) => EmptyCollection.error(),
        onLoading: (context) => const LoadingIndicator(),
        onState: (context, state) {
          if (state.isEmpty) {
            return const EmptyCollection(
              text: 'Sem aulas hoje!',
              icon: Icons.calendar_today_sharp,
            );
          } else {
            final itemsTotal = state.length;
            return ListView.builder(
              itemCount: itemsTotal,
              itemBuilder: (context, index) => Padding(
                padding:
                    EdgeInsets.only(bottom: index == itemsTotal - 1 ? 16 : 0),
                child: CourseCard(
                  course: state[index],
                  weekDay: today.weekday,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

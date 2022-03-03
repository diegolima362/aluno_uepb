import 'dart:io';
import 'dart:math';

import 'package:aluno_uepb/app/core/presenter/widgets/responsive.dart';
import 'package:aluno_uepb/app/modules/courses/domain/extensions/courses_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/entities.dart';
import '../../widgets/widgets.dart';

class CoursesCardList extends HookWidget {
  final List<CourseEntity> courses;

  const CoursesCardList({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final horizontalController = useScrollController();
    final verticalController = useScrollController();

    final width = Modular.get<ResponsiveSize>().w(context);

    final days = List<int>.generate(5, (i) => i + 1);

    final atDay = <List<CourseEntity>>[];

    for (var i in days) {
      atDay.add(courses.where((c) => c.hasClassAtDay(i)).toList());
    }

    return Scrollbar(
      controller: horizontalController,
      isAlwaysShown: (Platform.isAndroid || Platform.isIOS) ? false : true,
      child: ListView.builder(
        controller: horizontalController,
        itemCount: atDay.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final c = atDay[index];

          c.sort((a, b) => a
              .scheduleAtDay(index + 1)
              .time
              .compareTo(b.scheduleAtDay(index + 1).time));

          return SizedBox(
            width: min(width, 1080),
            child: Column(
              children: [
                Text(
                  WeekDay.daysIntMap[index + 1]!,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
                c.isEmpty
                    ? Card(
                        child: SizedBox(
                          height: 50,
                          child: Center(
                            child: Text(
                              'Sem aulas',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: verticalController,
                          child: Column(
                            children: c
                                .map((e) => CourseCard(
                                      course: e,
                                      weekDay: index + 1,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

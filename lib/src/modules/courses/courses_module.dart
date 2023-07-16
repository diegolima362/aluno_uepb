import 'package:flutter_modular/flutter_modular.dart';

import 'data/repositories/course_repository.dart';
import 'data/repositories/history_repository.dart';
import 'external/course_isar_local_datasource.dart';
import 'external/history_isar_local_datasource.dart';
import 'ui/pages/pages.dart';
import 'ui/reducers/reducers.dart';

class CoursesModule extends Module {
  @override
  final List<Bind> binds = [
    //
    Bind.lazySingleton((i) => CourseIsarLocalDataSource(i()), export: true),
    Bind.lazySingleton((i) => CourseRepository(i(), i()), export: true),

    //
    Bind.lazySingleton((i) => HistoryIsarLocalDataSource(i()), export: true),
    Bind.lazySingleton((i) => HistoryRepository(i(), i()), export: true),
    //
    Bind.singleton<CourseReducer>(
      (i) => CourseReducer(i()),
      onDispose: (i) => i.dispose(),
    ),
    Bind.singleton<TodayScheduleReducer>(
      (i) => TodayScheduleReducer(i()),
      onDispose: (i) => i.dispose(),
    ),
    Bind.singleton<ScheduleReducer>(
      (i) => ScheduleReducer(i()),
      onDispose: (i) => i.dispose(),
    ),
    Bind.singleton<HistoryReducer>(
      (i) => HistoryReducer(i()),
      onDispose: (i) => i.dispose(),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const CoursesPage()),
    ChildRoute('/today/', child: (_, __) => const TodaysSchedulePage()),
    ChildRoute('/schedule/', child: (_, __) => const FullSchedulePage()),
    ChildRoute('/history/', child: (_, __) => const HistoryPage()),
  ];
}

import 'package:flutter_modular/flutter_modular.dart';

import '../profile/profile_module.dart';
import 'data/datasources/course_datasource.dart';
import 'data/datasources/history_datasource.dart';
import 'data/repositories/course_repository.dart';
import 'data/repositories/history_repository.dart';
import 'external/course_isar_local_datasource.dart';
import 'external/history_isar_local_datasource.dart';
import 'ui/pages/pages.dart';
import 'ui/reducers/reducers.dart';

class CoursesModule extends Module {
  @override
  List<Module> get imports => [ProfileModule()];

  @override
  void binds(i) {
    i
      ..addSingleton<CourseLocalDataSource>(CourseIsarLocalDataSource.new)
      ..addSingleton<HistoryLocalDataSource>(HistoryIsarLocalDataSource.new)
      //
      ..addSingleton(CourseRepository.new)
      ..addSingleton(HistoryRepository.new)
      //
      ..addSingleton(CourseReducer.new)
      ..addSingleton(TodayScheduleReducer.new)
      ..addSingleton(ScheduleReducer.new)
      ..addSingleton(HistoryReducer.new);
  }

  @override
  void routes(r) {
    r
      ..child('/', child: (context) => const CoursesPage())
      ..child('/today/', child: (context) => const TodaysSchedulePage())
      ..child('/schedule/', child: (context) => const FullSchedulePage())
      ..child('/history/', child: (context) => const HistoryPage());
  }
}

import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/academic_local_datasource.dart';
import 'external/datasouces/academic_remote_datasource.dart';
import 'infra/repositories/academic_repository.dart';
import 'presenter/courses/courses_page.dart';
import 'presenter/courses/courses_store.dart';
import 'presenter/schedule/schedule_page.dart';
import 'presenter/schedule/schedule_store.dart';
import 'presenter/today/today_page.dart';
import 'presenter/today/today_store.dart';

class CoursesModule extends Module {
  static List<Bind> export = [
    // usecases
    Bind.singleton((i) => GetCourses(i())),

    // datasources
    Bind.singleton((i) => AcademicLocalDatasource(i())),
    Bind.singleton((i) => AcademicRemoteDatasource(i(), i())),

    // repositories
    Bind.singleton((i) => AcademicRepository(i(), i())),
  ];

  @override
  final List<Bind> binds = [
    // usecases
    Bind.singleton((i) => GetTodaysClasses(i())),
    //stores
    Bind.singleton((i) => TodayStore(i())),
    Bind.singleton((i) => ScheduleStore(i())),
    Bind.singleton((i) => CoursesStore(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const TodayPage()),
    ChildRoute('/schedule', child: (_, __) => const SchedulePage()),
    ChildRoute('/rdm', child: (_, __) => const CoursesPage()),
  ];
}

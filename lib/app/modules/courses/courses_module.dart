import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/local_datasource.dart';
import 'external/datasouces/remote_datasource.dart';
import 'infra/repositories/courses_repository.dart';
import 'presenter/courses/courses_page.dart';
import 'presenter/courses/courses_store.dart';
import 'presenter/details/details_page.dart';
import 'presenter/schedule/schedule_page.dart';
import 'presenter/schedule/schedule_store.dart';
import 'presenter/today/today_page.dart';
import 'presenter/today/today_store.dart';

class CoursesModule extends Module {
  static List<Bind> export = [
    // repositories
    Bind.lazySingleton((i) => CoursesRepository(i(), i(), i())),

    // usecases
    Bind.lazySingleton((i) => GetCourses(i())),
    Bind.lazySingleton((i) => GetCourseById(i())),
    Bind.lazySingleton((i) => GetRDM(i(), i())),

    // datasources
    Bind.lazySingleton((i) => CoursesLocalDatasource(i())),
    Bind.lazySingleton((i) => CoursesRemoteDatasource(i())),
  ];

  @override
  final List<Bind> binds = [
    // usecases
    Bind.lazySingleton((i) => GetTodaysClasses(i())),

    //stores
    Bind.singleton((i) => TodayStore(i())),
    Bind.lazySingleton((i) => ScheduleStore(i())),

    Bind.lazySingleton((i) => CoursesStore(i(), i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, __) => const TodayPage(),
      duration: Duration.zero,
    ),
    ChildRoute(
      '/schedule/',
      child: (_, __) => const SchedulePage(),
    ),
    ChildRoute(
      '/rdm/',
      child: (_, __) => const CoursesPage(),
      duration: Duration.zero,
    ),
    ChildRoute(
      '/details/',
      child: (_, args) => CourseDetailsPage(course: args.data),
    ),
  ];
}

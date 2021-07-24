import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'full_schedule/full_schedule_controller.dart';
import 'full_schedule/full_schedule_page.dart';
import 'today_schedule/today_schedule_controller.dart';
import 'today_schedule/today_schedule_page.dart';

class ScheduleModule extends Module {
  static final TransitionType _secondaryTransition = TransitionType.downToUp;

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => TodayScheduleController(i.get<DataController>())),
    Bind.lazySingleton((i) => FullScheduleController(i.get<DataController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (context, args) => TodaySchedulePage(),
    ),
    ChildRoute(
      '/full',
      child: (_, __) => FullSchedulePage(),
      transition: _secondaryTransition,
    ),
  ];
}

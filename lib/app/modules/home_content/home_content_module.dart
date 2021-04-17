import 'package:aluno_uepb/app/modules/home_content/full_schedule/full_schedule_controller.dart';
import 'package:aluno_uepb/app/modules/home_content/full_schedule/full_schedule_page.dart';
import 'package:aluno_uepb/app/modules/home_content/home_content_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_content_controller.dart';

class HomeContentModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => HomeContentController()),
    Bind.singleton((i) => FullScheduleController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomeContentPage()),
    ChildRoute('/list', child: (_, args) => FullSchedulePage()),
  ];
}

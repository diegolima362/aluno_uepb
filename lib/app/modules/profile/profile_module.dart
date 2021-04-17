import 'package:aluno_uepb/app/modules/profile/history/history_controller.dart';
import 'package:aluno_uepb/app/modules/profile/history/history_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details/details_page.dart';
import 'profile_controller.dart';
import 'profile_page.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => ProfileController()),
    Bind.singleton((i) => HistoryController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => ProfilePage()),
    ChildRoute('details', child: (_, __) => DetailsPage()),
    ChildRoute('history', child: (_, __) => HistoryPage()),
  ];
}

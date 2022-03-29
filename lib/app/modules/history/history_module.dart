import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/local_datasource.dart';
import 'external/datasouces/remote_datasource.dart';
import 'infra/repositories/history_repository.dart';
import 'presenter/history/history_page.dart';
import 'presenter/history/history_store.dart';

class HistoryModule extends Module {
  static List<Bind> export = [
    // usecases
    Bind.lazySingleton((i) => GetHistory(i())),

    // datasources
    Bind.lazySingleton((i) => HistoryLocalDatasource(i())),
    Bind.lazySingleton((i) => HistoryRemoteDatasource(i())),

    // repositories
    Bind.lazySingleton((i) => HistoryRepository(i(), i(), i())),
  ];

  @override
  final List<Bind> binds = [Bind.lazySingleton((i) => HistoryStore(i()))];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => HistoryPage())
  ];
}

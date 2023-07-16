import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/profile_datasources.dart';
import 'data/repositories/profile_repository.dart';
import 'external/profile_isar_local_datasource.dart';
import 'reducers/profile_reducer.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    //
    Bind.singleton<ProfileLocalDataSource>(
        (i) => ProfileIsarLocalDataSource(i()),
        export: true),

    //
    Bind.singleton((i) => ProfileRepository(i(), i()), export: true),
    //
    Bind.singleton((i) => ProfileReducer(i()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];
}

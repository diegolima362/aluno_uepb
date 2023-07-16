import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/preferences_local_datasource.dart';
import 'data/repositories/preference_repository.dart';
import 'external/datasources/preferences_isar_local_datasource.dart';
import 'external/datasources/preferences_mock_remote_datasource.dart';
import 'reducers/preferences_reducer.dart';
import 'ui/preferences_page.dart';

class PreferencesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<PreferencesLocalDataSource>(
      (i) => PreferencesIsarLocalDataSource(i()),
      export: true,
    ),
    Bind.singleton<PreferencesRemoteDataSource>(
      (i) => PreferencesMockRemoteDataSource(),
      export: true,
    ),
    Bind.singleton((i) => PreferencesRepository(i(), i()), export: true),
    Bind.singleton((i) => PreferenceReducer(i(), i()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const PreferencesPage()),
  ];
}

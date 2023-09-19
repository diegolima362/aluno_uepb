import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/shared_module.dart';
import 'data/datasources/preferences_local_datasource.dart';
import 'data/repositories/preference_repository.dart';
import 'external/datasources/preferences_isar_local_datasource.dart';
import 'external/datasources/preferences_mock_remote_datasource.dart';
import 'reducers/preferences_reducer.dart';
import 'ui/preferences_page.dart';

class PreferencesModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void exportedBinds(i) {}

  @override
  void binds(i) {
    i
      ..addSingleton<PreferencesLocalDataSource>(
          PreferencesIsarLocalDataSource.new)
      ..addSingleton<PreferencesRemoteDataSource>(
          PreferencesMockRemoteDataSource.new)
      ..addSingleton(PreferencesRepository.new)
      ..addSingleton(PreferenceReducer.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const PreferencesPage());
  }
}

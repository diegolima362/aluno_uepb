import 'package:flutter_modular/flutter_modular.dart';

import 'data/datasources/profile_datasources.dart';
import 'data/repositories/profile_repository.dart';
import 'external/profile_isar_local_datasource.dart';
import 'reducers/profile_reducer.dart';

class ProfileModule extends Module {
  @override
  void exportedBinds(i) {
    i
      ..addSingleton<ProfileLocalDataSource>(ProfileIsarLocalDataSource.new)
      ..addSingleton(ProfileRepository.new)
      ..addSingleton(ProfileReducer.new);
  }

  @override
  void binds(i) {
    i
      ..addSingleton<ProfileLocalDataSource>(ProfileIsarLocalDataSource.new)
      ..addSingleton(ProfileRepository.new)
      ..addSingleton(ProfileReducer.new);
  }
}

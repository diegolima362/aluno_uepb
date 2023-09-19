import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/shared_module.dart';
import 'data/datasources/profile_datasources.dart';
import 'data/repositories/profile_repository.dart';
import 'domain/reducers/profile_reducer.dart';
import 'external/profile_isar_local_datasource.dart';
import 'ui/profile_page.dart';

class ProfileModule extends Module {
  @override
  List<Module> get imports => [SharedModule()];

  @override
  void exportedBinds(i) {
    i
      ..addSingleton<ProfileLocalDataSource>(ProfileIsarLocalDataSource.new)
      ..addSingleton<ProfileRepository>(ProfileRepository.new)
      ..addSingleton<ProfileReducer>(
        ProfileReducer.new,
        config: BindConfig(onDispose: (e) => e.dispose()),
      );
  }

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const ProfilePage());
  }
}

import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasouces/local_datasource.dart';
import 'external/datasouces/remote_datasource.dart';
import 'infra/repositories/profile_repository.dart';
import 'presenter/profile/profile_page.dart';
import 'presenter/profile/profile_store.dart';

class ProfileModule extends Module {
  static List<Bind> export = [
    // usecases
    Bind.lazySingleton((i) => GetProfile(i())),

    // datasources
    Bind.lazySingleton((i) => ProfileLocalDatasource(i())),
    Bind.lazySingleton((i) => ProfileRemoteDatasource(i())),

    // repositories
    Bind.lazySingleton((i) => ProfileRepository(i(), i(), i())),

    // stores
    Bind.lazySingleton((i) => ProfileStore(i())),
  ];

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const ProfilePage())
  ];
}

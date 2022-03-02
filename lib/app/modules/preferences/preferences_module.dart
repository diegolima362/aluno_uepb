import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/preferences_datasource.dart';
import 'infra/repositories/preferences_repository.dart';
import 'presenter/pages/preferences_page.dart';

class PreferencesModule extends Module {
  static List<Bind> export = [
    Bind.singleton((i) => GetThemeMode(i())),
    Bind.singleton((i) => StoreThemeMode(i())),
    Bind.singleton((i) => ClearDatabase(i())),
    Bind.singleton((i) => PreferencesRepository(i())),
    Bind.singleton((i) => PreferencesDatasource(i())),
  ];

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const PreferencesPage()),
  ];
}

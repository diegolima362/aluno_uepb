import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/usecases.dart';
import 'external/datasources/preferences_datasource.dart';
import 'infra/repositories/preferences_repository.dart';
import 'presenter/preferences/preferences_page.dart';

class PreferencesModule extends Module {
  static List<Bind> export = [
    Bind.lazySingleton((i) => GetThemeMode(i())),
    Bind.lazySingleton((i) => GetPreferences(i())),
    Bind.lazySingleton((i) => SetPreferences(i())),
    Bind.lazySingleton((i) => StoreThemeMode(i())),
    Bind.lazySingleton((i) => ClearDatabase(i())),
    Bind.lazySingleton((i) => PreferencesDatasource(i())),
    Bind.lazySingleton((i) => PreferencesRepository(i())),
  ];

  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, __) => const PreferencesPage()),
  ];
}

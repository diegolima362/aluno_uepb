import 'package:result_dart/result_dart.dart';

import '../../core/exceptions/app_exception.dart';
import '../../interactor/datasources/academic_datasource.dart';
import '../../interactor/models/preferences.dart';
import '../../interactor/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  final AppLocalDataSource _localDataSource;

  PreferencesRepositoryImpl(this._localDataSource);

  @override
  AsyncResult<Unit, AppException> clearPreferences() async {
    await _localDataSource.clearPreferences();
    return const Success(unit);
  }

  @override
  AsyncResult<Preferences, AppException> fetchPreferences() async {
    final preferences = await _localDataSource.fetchPreferences();
    if (preferences == null) {
      final newPreferences = Preferences.defaultPreferences();
      await _localDataSource.cachePreferences(newPreferences);
      return Success(newPreferences);
    }
    return Success(preferences);
  }

  @override
  AsyncResult<Unit, AppException> savePreferences(Preferences data) async {
    await _localDataSource.cachePreferences(data);
    return const Success(unit);
  }
}

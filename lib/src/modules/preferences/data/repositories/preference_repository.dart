import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/types/open_protocol.dart';
import '../../../../shared/data/types/types.dart';
import '../../../../shared/external/datasources/implementations.dart';
import '../../models/preferences.dart';
import '../datasources/preferences_local_datasource.dart';

class PreferencesRepository {
  final PreferencesLocalDataSource _localDataSource;
  final PreferencesRemoteDataSource _remoteDataSource;
  Preferences _preferences = Preferences.defaultPreferences();

  PreferencesRepository(this._localDataSource, this._remoteDataSource);

  Preferences get preferences => _preferences;
  final _protocols = <OpenProtocolSpec>[];

  AsyncResult<List<OpenProtocolSpec>, AppException> fetchProtocols() async {
    if (_protocols.isNotEmpty) {
      return Success(_protocols);
    }

    final result = await _remoteDataSource.fetchProtocols();
    return result.fold(
      (success) {
        _protocols.addAll(success);
        return Success(success);
      },
      (failure) => Failure(failure),
    );
  }

  AsyncResult<Preferences, AppException> getPreferences() async {
    final result = await _localDataSource.load();
    return result.fold(
      (success) {
        _preferences = success;
        return Success(success);
      },
      (failure) => Failure(failure),
    );
  }

  AsyncResult<Preferences, AppException> updatePreferecense(Preferences data) {
    _preferences = data;
    return _localDataSource.save(data);
  }

  Future<void> clear() async {
    _preferences = Preferences.defaultPreferences();
    await _localDataSource.clear();
  }

  AsyncResult<Preferences, AppException> updateTheme(ThemeMode themeMode) {
    return updatePreferecense(_preferences.copyWith(themeMode: themeMode));
  }

  AsyncResult<Preferences, AppException> updateSeedColor(Color? seedColor) {
    return updatePreferecense(
      _preferences.copyWithNullable(
        seedColor: seedColor,
        protocolSpec: _preferences.protocolSpec,
        lastSync: _preferences.lastSync,
      ),
    );
  }

  AsyncResult<Preferences, AppException> updateImplementation(
    DataSourceImplementation implementation,
  ) {
    return updatePreferecense(
        _preferences.copyWith(implementation: implementation));
  }

  AsyncResult<Preferences, AppException> updateSpecs(OpenProtocolSpec? specs) {
    return updatePreferecense(_preferences.copyWithNullable(
      protocolSpec: specs,
      lastSync: _preferences.lastSync,
      seedColor: _preferences.seedColor,
    ));
  }

  AsyncResult<Preferences, AppException> updateBackgroundSync(bool value) {
    return updatePreferecense(_preferences.copyWith(backgroundSync: value));
  }

  AsyncResult<Preferences, AppException> updateShowNotifications(bool value) {
    return updatePreferecense(_preferences.copyWith(showNotifications: value));
  }

  AsyncResult<Preferences, AppException> updateLastSync(DateTime? lastSync) {
    return updatePreferecense(
      _preferences.copyWithNullable(
        protocolSpec: _preferences.protocolSpec,
        lastSync: lastSync,
        seedColor: _preferences.seedColor,
      ),
    );
  }
}

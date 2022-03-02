import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../modules/preferences/domain/erros/erros.dart';
import '../../../modules/preferences/domain/usecases/usecases.dart';
import '../../infra/drivers/connectivity_driver.dart';
import 'auth_store.dart';

typedef PreferencesStoreType
    = NotifierStore<PreferencesFailure, PreferencesState>;

class PreferencesStore extends PreferencesStoreType {
  final IGetThemeMode getThemeMode;
  final IStoreThemeMode storeThemeMode;
  final IConnectivityDriver connectivity;
  final IAuthStore authStore;

  PreferencesStore(
      this.getThemeMode, this.storeThemeMode, this.connectivity, this.authStore)
      : super(PreferencesState());

  bool get isOnline {
    if (!state.isOnline) _checkNetwork();

    return state.isOnline;
  }

  void _checkNetwork() async {
    final result = await connectivity.isOnline;
    update(state.copyWith(isOnline: result));
  }

  void checkStatus() {
    connectivity.connectionStream.listen((e) => _checkNetwork());

    _checkNetwork();
  }

  Future<void> getData() async {
    setLoading(true);
    final result = await getThemeMode();

    result.fold(
      (l) {
        AsukaSnackbar.warning(l.message);
        setError(l);
      },
      (r) => update(state.copyWith(themeMode: r)),
    );
  }

  Future<void> setTheme(ThemeMode val) async {
    final result = await storeThemeMode(val);

    result.fold(
      (l) => AsukaSnackbar.warning(l.message),
      (r) => update(state.copyWith(themeMode: val)),
    );
  }

  ThemeMode get currentTheme => state.themeMode;
}

class PreferencesState {
  final ThemeMode themeMode;
  final bool isOnline;

  PreferencesState({this.themeMode = ThemeMode.system, this.isOnline = true});

  PreferencesState copyWith({
    ThemeMode? themeMode,
    bool? isOnline,
  }) {
    return PreferencesState(
      themeMode: themeMode ?? this.themeMode,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

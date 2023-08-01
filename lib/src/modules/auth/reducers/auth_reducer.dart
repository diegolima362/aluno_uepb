import 'package:asp/asp.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/services/worker_service.dart';
import '../../courses/data/repositories/course_repository.dart';
import '../../courses/data/repositories/history_repository.dart';
import '../../preferences/atoms/preferences_atom.dart';
import '../../preferences/data/repositories/preference_repository.dart';
import '../../profile/data/repositories/profile_repository.dart';
import '../atoms/auth_atom.dart';
import '../atoms/sign_in_atom.dart';
import '../data/repositories/auth_repository.dart';

class AuthReducer extends Reducer {
  final AuthRepository _repository;

  AuthReducer(this._repository) {
    on(() => [fetchCurrentUser], _fetchCurrentUser);
    on(() => [signInAction], _signIn);
    on(() => [signOutAction], _signOut);
    on(() => [resetAuthAction], _resetAuth);
  }

  void _fetchCurrentUser() async {
    final result = await _repository.fetchCurrentUser();
    result.fold(
      (success) => userState.value = success,
      (failure) => userState.value = null,
    );
  }

  void _resetAuth() {
    usernameState.value = userState.value?.username ?? '';
    passwordState.value = userState.value?.password ?? '';
    signInResultState.value = null;
    userState.value = null;
  }

  Future<void> _signIn() async {
    signInLoadingState.value = true;
    signInResultState.value = null;

    final result = await _repository.signIn(
      usernameState.value,
      passwordState.value,
    );

    final user = result.getOrNull();
    if (user != null) {
      userState.setValue(user);
    }

    signInResultState.value = result;
    signInLoadingState.value = false;
  }

  Future<void> _signOut() async {
    await Future.wait([
      Modular.get<CourseRepository>().clear(),
      Modular.get<HistoryRepository>().clear(),
      Modular.get<PreferencesRepository>().clear(),
      Modular.get<ProfileRepository>().clear(),
      Modular.get<WorkerService>().cancelAll(),
      _repository.signOut(),
    ]);

    fetchPreferences();

    userState.value = null;
  }
}

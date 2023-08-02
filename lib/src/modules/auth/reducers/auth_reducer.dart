import 'package:asp/asp.dart';

import '../../courses/ui/atoms/courses_atom.dart';
import '../../courses/ui/atoms/history_atom.dart';
import '../../preferences/atoms/preferences_atom.dart';
import '../../profile/atoms/profile_atom.dart';
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
    clearCoursesData();
    clearHistoryData();
    clearPreferencesData();
    clearProfileData();
    await _repository.signOut();

    fetchPreferences();

    userState.value = null;
  }
}

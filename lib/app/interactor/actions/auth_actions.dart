import 'package:result_dart/result_dart.dart';

import '../../injector.dart';
import '../../interactor/atoms/atoms.dart';
import '../datasources/academic_datasource.dart';
import '../repositories/repositories.dart';

final _repository = injector.get<AuthRepository>();

Future<void> login(String username, String password) async {
  setAuthLoading(true);
  setAuthResult(null);

  await _repository.login(username, password).fold(
        (data) => setUserState(data),
        (err) => setAuthResult(Failure(err)),
      );

  setAuthLoading(false);
}

Future<void> fetchCurrentUser() async {
  setAuthLoading(true);
  setAuthResult(null);

  await _repository.fetchCurrentUser().fold(
        (data) => setUserState(data),
        (err) => setAuthResult(Failure(err)),
      );

  setAuthLoading(false);
}

Future<void> logout() async {
  setAuthLoading(true);
  setAuthResult(null);
  await _repository.logout();

  await injector.get<AppLocalDataSource>().clearData();

  setUserState(null);
  setAuthLoading(false);
}

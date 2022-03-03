import 'package:fpdart/fpdart.dart';

import '../../domain/errors/errors.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/types/types.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDatasource dataSource;

  AuthRepository(this.dataSource);

  @override
  Future<EitherLoggedInfo> signIn(String register, String password) async {
    try {
      final user = await dataSource.signIn(register, password);
      return Right(Option.of(user));
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherSession> signedSession(String credentials) async {
    try {
      final session = await dataSource.signedSession(credentials);
      return Right(session);
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherLoggedInfo> loggedUser() async {
    try {
      final result = await dataSource.currentUser;

      if (result != null) {
        return Right(Option.of(result));
      } else {
        return Right(Option.none());
      }
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<EitherLoggedInfo> logout() async {
    try {
      await dataSource.logout();
      return Right(Option.none());
    } on AuthFailure catch (e) {
      return Left(e);
    }
  }
}

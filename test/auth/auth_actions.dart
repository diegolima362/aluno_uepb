import 'package:aluno_uepb/app/core/exceptions/app_exception.dart';
import 'package:aluno_uepb/app/injector.dart';
import 'package:aluno_uepb/app/interactor/actions/auth_actions.dart';
import 'package:aluno_uepb/app/interactor/atoms/auth_atoms.dart';
import 'package:aluno_uepb/app/interactor/models/user.dart';
import 'package:aluno_uepb/app/interactor/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository authRepository;

  setUpAll(() {
    authRepository = MockAuthRepository();
    injector
      ..addInstance<AuthRepository>(authRepository)
      ..commit();
  });

  setUp(() {
    // reset auth state
    setAuthLoading(false);
    setAuthResult(null);
    setUserState(null);
  });

  group('Fetch Logged User', () {
    test(
      'Ensure the state is changed in the defined order with success',
      () async {
        when(() => authRepository.fetchCurrentUser()).thenAnswer(
          (_) async => Success(User(username: 'user', password: 'password')),
        );

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);

        expect(authLoadingState.next(), completion(isTrue));
        expect(authResultState.next(), completion(isA<Success>()));
        expect(userState.next(), completion(isA<User>()));

        await fetchCurrentUser();

        expect(authLoadingState.state, isFalse);
      },
    );

    test(
      'Ensure the state is changed in the defined order with failure',
      () async {
        when(() => authRepository.fetchCurrentUser()).thenAnswer(
          (_) async => Failure(AppException('No user logged in')),
        );

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);

        expect(authLoadingState.next(), completion(isTrue));
        expect(authResultState.next(), completion(isA<Failure>()));

        await fetchCurrentUser();

        expect(userState.state, isNull);
        expect(authLoadingState.state, isFalse);
        expect(authResultState.state?.exceptionOrNull()?.message,
            equals('No user logged in'));
      },
    );
  });

  group('Sign In', () {
    test(
      'Ensure the state is changed in the defined order with success',
      () async {
        when(() => authRepository.login('user', 'password')).thenAnswer(
          (_) async => Success(User(username: 'user', password: 'password')),
        );

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);

        expect(authLoadingState.next(), completion(isTrue));
        expect(authResultState.next(), completion(isA<Success>()));
        expect(userState.next(), completion(isA<User>()));

        await login('user', 'password');

        expect(authLoadingState.state, isFalse);
      },
    );

    test(
      'Ensure the state is changed in the defined order with failure',
      () async {
        when(() => authRepository.login('user', 'password')).thenAnswer(
          (_) async => Failure(AppException('error')),
        );

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);

        expect(authLoadingState.next(), completion(isTrue));
        expect(authResultState.next(), completion(isA<Failure>()));

        await login('user', 'password');

        expect(userState.state, isNull);
        expect(authLoadingState.state, isFalse);
      },
    );
  });

  group('Sign Out', () {
    test(
      'Ensure the state is changed in the defined order',
      () async {
        when(() => authRepository.logout()).thenAnswer((_) async => unit);

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);

        expect(authLoadingState.next(), completion(isTrue));

        await logout();

        expect(authLoadingState.state, isFalse);
        expect(authResultState.state, isNull);
        expect(userState.state, isNull);
      },
    );
  });
}

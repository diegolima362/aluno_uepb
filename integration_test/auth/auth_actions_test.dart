import 'package:aluno_uepb/app/app_widget.dart';
import 'package:aluno_uepb/app/injector.dart';
import 'package:aluno_uepb/app/interactor/models/preferences.dart';
import 'package:aluno_uepb/app/interactor/models/user.dart';
import 'package:aluno_uepb/app/interactor/repositories/auth_repository.dart';
import 'package:aluno_uepb/app/interactor/repositories/preferences_repository.dart';
import 'package:aluno_uepb/routes.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:routefly/routefly.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockPreferencesRepository extends Mock implements PreferencesRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AuthRepository authRepository;
  late PreferencesRepository preferencesRepository;

  setUpAll(() {
    registerFallbackValue(Preferences.defaultPreferences());

    authRepository = MockAuthRepository();
    preferencesRepository = MockPreferencesRepository();

    injector
      ..addInstance<PreferencesRepository>(preferencesRepository)
      ..addInstance<AuthRepository>(authRepository)
      ..commit();
  });

  group('Sign In', () {
    testWidgets(
      'Should go to Select Implementation Page',
      (tester) async {
        when(() => preferencesRepository.fetchPreferences()).thenAnswer(
          (_) async => Success(Preferences.defaultPreferences()),
        );

        // Load app widget.
        await tester.pumpWidget(const AppWidget());

        await tester.pumpAndSettle();

        final route = Routefly.currentUri.path;
        expect(route, routePaths.login);
      },
    );

    testWidgets(
      'Should sign in and go to Home Page',
      (tester) async {
        // Mocking the sign in method.
        when(() => authRepository.login(any<String>(), any<String>()))
            .thenAnswer((_) async {
          return Success(User(
            username: 'test',
            password: 'test',
          ));
        });

        when(() => preferencesRepository.fetchPreferences()).thenAnswer(
          (_) async => Success(Preferences.defaultPreferences()),
        );

        when(() => preferencesRepository.savePreferences(any<Preferences>())).thenAnswer(
          (_) async => Success.unit(),
        );

        // Load app widget.
        await tester.pumpWidget(const AppWidget());

        await tester.pumpAndSettle();

        // add sign in info

        await tester.tap(find.byKey(const Key('sign_in_button')));

        // Wait for the app to load.
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 5));
      },
    );
  });
}

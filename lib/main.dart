import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/landing_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static AuthBase auth = Auth();

  bool _isDarkMode(Box box) {
    final darkMode = box.get('darkMode', defaultValue: false);
    final colorValue = box.get(
      'color',
      defaultValue: CustomThemes.defaultAccentColor.value,
    );

    CustomThemes.setColor(Color(colorValue));
    CustomThemes.isDark = darkMode;

    return darkMode;
  }

  SystemUiOverlayStyle _getStyle(bool darkMode) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: HiveDatabase.onDarkModeStateChanged,
      builder: (context, box, child) {
        final darkMode = _isDarkMode(box);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _getStyle(darkMode),
          child: MultiProvider(
            providers: [
              Provider<FirebaseAnalytics>.value(value: analytics),
              Provider<FirebaseAnalyticsObserver>.value(value: observer),
              Provider<AuthBase>.value(value: auth)
            ],
            child: MaterialApp(
              title: 'Aluno UEPB',
              home: LandingPage(),
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              theme: CustomThemes.light,
              darkTheme: CustomThemes.dark,
              navigatorObservers: <NavigatorObserver>[observer],
              supportedLocales: [const Locale('pt', 'BR')],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
            ),
          ),
        );
      },
    );
  }
}

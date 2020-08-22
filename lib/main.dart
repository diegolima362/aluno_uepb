import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/themes/custom_themes.dart';
import 'package:cau3pb/views/landing_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: HiveDatabase.onDarkModeStateChanged,
      builder: (context, box, child) {
        final darkMode = box.get('darkMode', defaultValue: false);
        final colorValue = box.get('color', defaultValue: CustomThemes.accentColor.value);
        CustomThemes.setColor(Color(colorValue));
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _getTheme(darkMode),
          child: Provider<AuthBase>(
            create: (context) => Auth(),
            child: MaterialApp(
              title: 'Aluno UEPB',
              themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
              theme: CustomThemes.light,
              darkTheme: CustomThemes.dark,
              home: LandingPage(),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: [const Locale('pt', 'BR')],
            ),
          ),
        );
      },
    );
  }

  SystemUiOverlayStyle _getTheme(bool darkMode) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
    );
  }
}

import 'package:asp/asp.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'modules/auth/atoms/auth_atom.dart';
import 'modules/preferences/atoms/preferences_atom.dart';
import 'shared/data/datasources/remote_datasource.dart';
import 'shared/ui/theme/theme.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userState
        ..removeListener(userListener)
        ..addListener(userListener);
      FlutterNativeSplash.remove();
    });
  }

  void userListener() {
    final user = userState.value;
    Modular.get<AcademicRemoteDataSource>().setUser(user);

    if (user == null) {
      Modular.to.navigate('/auth/');
    } else {
      Modular.to.navigate('/app/courses/today/');
    }
  }

  @override
  void dispose() {
    userState.removeListener(userListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (themeMode, seedColor) = context.select(
      () => (
        themeModeState.value,
        seedColorState.value,
      ),
    );

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'Hub',
          theme: lightTheme(
            seedColor ?? Colors.black,
            seedColor != null ? null : lightDynamic,
          ),
          darkTheme: darkTheme(
            seedColor ?? Colors.white,
            seedColor != null ? null : darkDynamic,
          ),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}

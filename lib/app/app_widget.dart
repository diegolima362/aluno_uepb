import 'package:asuka/asuka.dart' as asuka;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/presenter/stores/preferences_store.dart';
import 'core/presenter/theme/theme.dart';

BuildContext? globalContext;

class Responsive extends StatelessWidget {
  final BuildContext? context;

  Responsive({Key? key, this.context}) : super(key: key) {
    globalContext = context;
  }

  @override
  Widget build(BuildContext context) => const AppWidget();
}

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends ModularState<AppWidget, PreferencesStore> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    store.getData();
    store.checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store.selectState,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Aluno UEPB',
          theme: AppTheme.theme(Color(store.state.seedColor)),
          darkTheme: AppTheme.theme(
            Color(store.state.seedColor),
            darkMode: true,
          ),
          themeMode: store.state.themeMode,
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          builder: asuka.builder,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          supportedLocales: const [Locale('pt', 'BR')],
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
        );
      },
    );
  }
}

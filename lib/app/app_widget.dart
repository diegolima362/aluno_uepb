import 'package:asuka/asuka.dart' as asuka;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/presenter/stores/preferences_store.dart';

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
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      child: AnimatedBuilder(
        animation: store.selectState,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'Aluno UEPB',
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
      ),
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
    );
  }
}

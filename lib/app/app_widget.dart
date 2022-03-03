import 'package:asuka/asuka.dart' as asuka;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _AppWidgetState extends ModularState<AppWidget, PreferencesStore>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    WidgetsBinding.instance?.addObserver(this);

    store.getData();
    store.checkStatus();

    _setTheme();
  }

  void _setTheme() {
    final isDarkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;

    var iconBrightness = Brightness.dark;
    var color = AppTheme.lightTheme.cardColor;

    if (store.state.themeMode == ThemeMode.dark ||
        (store.state.themeMode == ThemeMode.system && isDarkMode)) {
      iconBrightness = Brightness.light;
      color = AppTheme.themeDark.cardColor;
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: color,
      statusBarIconBrightness: iconBrightness,
      systemNavigationBarIconBrightness: iconBrightness,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      child: AnimatedBuilder(
        animation: store.selectState,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'Aluno UEPB',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.themeDark,
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

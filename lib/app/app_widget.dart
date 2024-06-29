import 'package:asp/asp.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:routefly/routefly.dart';

import '(ui)/theme/theme.dart';
import '../routes.g.dart';
import 'interactor/atoms/auth_atoms.dart';
import 'interactor/atoms/preferences_atoms.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with HookStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  @override
  Widget build(BuildContext context) {
    useAtomEffect((get) => get(authLoadingState), effect: (loading) {
      if (!loading) {
        final user = userState.state;
        if (user != null) {
          Routefly.navigate(routePaths.home);
        } else {
          Routefly.navigate(routePaths.login);
        }
      }
    });

    final themeMode = useAtomState(themeModeState);

    final textTheme = themeMode == ThemeMode.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    final theme = MaterialTheme(textTheme);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'uepb',
          theme: theme.lightHighContrast(),
          darkTheme: theme.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: Routefly.routerConfig(
            routes: routes,
            initialPath: routePaths.landing,
          ),
        );
      },
    );
  }
}

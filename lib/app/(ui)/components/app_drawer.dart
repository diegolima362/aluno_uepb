import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:routefly/routefly.dart';

import '../../../routes.g.dart';
import 'components.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with HookStateMixin {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      children: [
        Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyAppIcon(),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Symbols.today_sharp),
          label: Text('Aulas'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Symbols.calendar_today_sharp),
          label: Text('Horário'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Symbols.library_books_sharp),
          label: Text('Histórico'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Symbols.settings_sharp),
          label: Text('Configurações'),
        ),
      ],
    );
  }

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pop();
      case 1:
        Navigator.of(context).pop();
        Routefly.pushNavigate(routePaths.schedule);
      case 2:
        Navigator.of(context).pop();
        Routefly.pushNavigate(routePaths.history);
      case 3:
        Navigator.of(context).pop();
        Routefly.pushNavigate(routePaths.preferences);
      default:
        break;
    }
  }
}

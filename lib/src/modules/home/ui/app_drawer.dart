import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/domain/extensions/extensions.dart';
import '../../../shared/external/datasources/implementations.dart';
import '../../auth/atoms/auth_atom.dart';
import '../../preferences/atoms/preferences_atom.dart';
import '../../profile/domain/atoms/profile_atom.dart';
import '../../profile/domain/models/profile.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profile = context.select(() => profileState.value);

    final implementation = context.select(() => implementationState.value);
    final spec = context.select(() => protocolSpecState.value);

    final title = implementation == DataSourceImplementation.openProtocol
        ? spec?.title ?? ''
        : implementation.title;

    return SafeArea(
      child: NavigationDrawer(
        onDestinationSelected: onDestinationSelected,
        selectedIndex: selectedIndex,
        children: [
          SizedBox(
            height: 80,
            child: DrawerHeader(
              child: Text(
                profile != null ? 'Olá, ${profile.firstName}!' : title,
                style: context.textTheme.titleLarge,
              ),
            ),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home_filled),
            label: Text('Início'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: Text('Horário'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.library_books_outlined),
            label: Text('Histórico'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.settings_outlined),
            label: Text('Configurações'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.logout_outlined),
            label: Text('Sair'),
          ),
        ],
      ),
    );
  }

  void onDestinationSelected(int index) {
    setState(() => selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pop();
      case 1:
        Navigator.of(context).pop();
        Modular.to.pushNamed('/app/courses/schedule/', forRoot: true);
      case 2:
        Navigator.of(context).pop();
        Modular.to.pushNamed('/app/courses/history/', forRoot: true);
      case 3:
        Navigator.of(context).pop();
        Modular.to.pushNamed('/app/preferences/', forRoot: true);
      case 4:
        Navigator.of(context).pop();
        showSignOutDialog(context);
      default:
        break;
    }
  }

  Future<void> showSignOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que quer sair?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            onPressed: () {
              signOutAction();
              Modular.to.navigate('/');
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

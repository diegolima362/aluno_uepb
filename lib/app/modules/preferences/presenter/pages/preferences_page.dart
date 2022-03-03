import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/presenter/stores/auth_store.dart';
import '../../../../core/presenter/stores/preferences_store.dart';
import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/usecases/usecases.dart';
import '../widgets/widgets.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleHeader(text: 'Configurar'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _themeSelector,
          const SizedBox(height: 8),
          _buildAboutApp(context),
          const SizedBox(height: 8),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget get _themeSelector {
    final store = Modular.get<PreferencesStore>();

    return ValueListenableBuilder<PreferencesState>(
      valueListenable: store.selectState,
      builder: (_, state, __) => ThemeSelector(
        initialTheme: state.themeMode,
        onSetTheme: (mode) => store.setTheme(mode ?? ThemeMode.system),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return ListTile(
      title: const Text(
        'Sair ',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async => await showDialog(
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
              child: const Text('Sair'),
              onPressed: () async {
                await Modular.get<PreferencesStore>()
                    .setTheme(ThemeMode.system);
                // await Modular.get<IRemoveLocalData>().call();
                await Modular.get<IClearDatabase>().call();

                await Modular.get<AuthStore>().signOut();

                Navigator.pop(context);
                Modular.to.navigate('/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutApp(BuildContext context) {
    return ListTile(
      title: const Text(
        'Sobre',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async => showAboutDialog(
        context: context,
        applicationName: 'Aluno UEPB',
        applicationVersion: '1.3.0',
        applicationIcon: const MyAppIcon(),
        useRootNavigator: false,
      ),
    );
  }
}

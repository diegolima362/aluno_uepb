import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../core/extensions/extensions.dart';
import '../../interactor/actions/preferences_actions.dart';
import '../../interactor/atoms/preferences_atoms.dart';
import '../components/components.dart';

const themeNames = <ThemeMode, String>{
  ThemeMode.light: 'Claro',
  ThemeMode.dark: 'Escuro',
  ThemeMode.system: 'Pelo sistema',
};

final _colors = [Colors.transparent, ...Colors.primaries];

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> with HookStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useAtomState(preferencesLoadingState);
    final error = useAtomState(preferencesResultState)?.exceptionOrNull();
    final preferences = useAtomState(preferencesState);

    Widget body;
    if (isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (error != null || preferences == null) {
      body = Center(child: Text(error.toString()));
    } else {
      body = ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          const SectionTitle('Tema'),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeModeState.state,
                title: const Text('Sistema'),
                onChanged: setThemeMode,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeModeState.state,
                title: const Text('Claro'),
                onChanged: setThemeMode,
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeModeState.state,
                title: const Text('Escuro'),
                onChanged: setThemeMode,
              ),
            ],
          ),
          if (false)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              title: const Text('Cor do Tema'),
              onTap: _pickColor,
              trailing: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: seedColorState.state ?? context.colors.primary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          const SectionTitle('Dados'),
          SwitchListTile(
            value: backgroundSyncState.state ?? false,
            onChanged: setBackgroundSync,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: const Text('Atualizações Automáticas'),
            subtitle: const Text(
              'Atualizar seus dados em segundo plano mesmo com o app fechado.',
            ),
          ),
          SwitchListTile(
            value: notificationsState.state ?? false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            onChanged: (backgroundSyncState.state ?? false)
                ? setShowNotifications
                : null,
            title: const Text('Notificar Atualizações'),
            subtitle: const Text(
              'Receber alertas sobre notas e faltas atualizadas.',
            ),
          ),
          const SectionTitle('Sobre'),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: const Text('Sobre o APP'),
            trailing: const Icon(Icons.info_outline),
            onTap: () => showDialog(
              context: context,
              useRootNavigator: false,
              builder: (context) => AboutDialog(
                applicationName: appName,
                applicationVersion: 'v$appVersion',
                applicationIcon: const MyAppIcon(),
                applicationLegalese: '${DateTime.now().year} - 362 Devs',
              ),
            ),
          ),
          ListTile(
            title: const Text('Veja como fui feito'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            trailing: const Icon(Icons.code),
            onTap: () {
              launchUrl(
                Uri.parse('https://github.com/diegolima362/aluno_uepb'),
              );
            },
          ),
          ListTile(
            title: const Text('Entre em contato'),
            trailing: const Icon(Icons.email_outlined),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            onTap: () {
              final emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'diego.ferreira@aluno.uepb.edu.br',
                query: encodeQueryParameters(
                  {'subject': 'Contato sobre o app 📧'},
                ),
              );

              launchUrl(emailLaunchUri);
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: body,
    );
  }

  void _pickColor() async {
    await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha uma cor'),
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              for (final color in _colors)
                GestureDetector(
                  onTap: () => setSeedColor(
                    color == Colors.transparent ? null : color,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        width: 2.0,
                        color: context.colors.onSurface.withOpacity(0.25),
                      ),
                    ),
                    child: Visibility(
                      visible: seedColorState.state == color ||
                          (seedColorState.state == null &&
                              color == Colors.transparent),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(context.colors.primary),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

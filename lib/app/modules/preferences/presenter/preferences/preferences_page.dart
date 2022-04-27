import 'package:aluno_uepb/app/core/presenter/stores/preferences_store.dart';
import 'package:aluno_uepb/app/core/presenter/theme/colors.dart';
import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:aluno_uepb/app/modules/preferences/domain/erros/erros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

const themeNames = <ThemeMode, String>{
  ThemeMode.light: 'Claro',
  ThemeMode.dark: 'Escuro',
  ThemeMode.system: 'Pelo sistema',
};

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<PreferencesStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      body:
          ScopedBuilder<PreferencesStore, PreferencesFailure, PreferencesState>(
        store: store,
        onLoading: (_) => const Center(child: CircularProgressIndicator()),
        onError: (_, __) => EmptyCollection.error(
          message: 'Erro ao obter Configurações',
        ),
        onState: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(text: 'Aparência'),
                ListTile(
                  title: const Text('Tema'),
                  subtitle: Text(themeNames[state.themeMode] ?? ''),
                  onTap: () => _selectTheme(
                    context,
                    state.themeMode,
                    store.setTheme,
                  ),
                ),
                ListTile(
                  title: const Text('Cor de destaque'),
                  trailing: ColorContainer(colorValue: state.seedColor),
                  onTap: () => _selectSeedColor(context, state),
                ),
                const Divider(height: 0),
                const SectionTitle(text: 'Atualizações'),
                ListTile(
                  title: const Text('Atualizar dados'),
                  subtitle: const Text(
                    'Permitir que o aplicativo verifique atualizações no '
                    'controle acadêmico mesmo quando o app estiver '
                    'fechado.',
                  ),
                  trailing: Switch(
                    value: state.allowWorker,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: store.toggleWorker,
                  ),
                ),
                ListTile(
                  title: const Text('Notificar mudanças'),
                  subtitle: const Text(
                    'Receber uma notificação quando os dados forem atualizados.',
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  trailing: Switch(
                    value: state.allowNotifications,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged:
                        state.allowWorker ? store.toggleNotifications : null,
                  ),
                ),
                const Divider(height: 0),
                const SectionTitle(text: 'Notificações'),
                ListTile(
                  title: const Text('Cancelar notificações pendentes'),
                  onTap: () => store.cancelPendingNotifications(),
                  trailing: const Icon(Icons.notifications_off_sharp),
                ),
                const Divider(height: 0),
                const SectionTitle(text: 'Sobre'),
                ListTile(
                  title: const Text('Sobre o APP'),
                  onTap: () => showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (context) => const CustomAboutDialog(),
                  ),
                ),
                ListTile(
                  title: const Text('Veja como fui feito'),
                  onTap: () {
                    launchUrl(
                      Uri.parse('https://github.com/diegolima362/aluno_uepb'),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Entre em contato'),
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
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _selectSeedColor(
      BuildContext context, PreferencesState state) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return CustomAlert<int>(
          title: 'Escolher cor',
          initialValue: state.seedColor,
          onValueChanged: Modular.get<PreferencesStore>().setColor,
          contentBuilder: (update, value) {
            return Wrap(
              alignment: WrapAlignment.center,
              children: appColors
                  .map(
                    (e) => GestureDetector(
                      onTap: () => update(e.value),
                      child: ColorContainer(
                        color: e,
                        useBorder: value == e.value,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }

  Future<dynamic> _selectTheme(
    BuildContext context,
    ThemeMode initialValue,
    void Function(ThemeMode?) onThemeSelected,
  ) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return CustomAlert<ThemeMode>(
          title: 'Escolher tema',
          initialValue: initialValue,
          onValueChanged: onThemeSelected,
          contentBuilder: (update, value) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Claro'),
                contentPadding: EdgeInsets.zero,
                leading: Radio<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: value,
                  onChanged: (newValue) => update(newValue),
                ),
              ),
              ListTile(
                title: const Text('Escuro'),
                contentPadding: EdgeInsets.zero,
                leading: Radio<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: value,
                  onChanged: (newValue) => update(newValue),
                ),
              ),
              ListTile(
                title: const Text('Pelo sistema'),
                contentPadding: EdgeInsets.zero,
                leading: Radio<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: value,
                  onChanged: (newValue) => update(newValue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

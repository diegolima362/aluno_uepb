import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/utils/connection_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_controller.dart';

import '../../routes.dart' as home;

class ProfileActionsInfoCard extends StatelessWidget {
  final ProfileController controller;

  const ProfileActionsInfoCard({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = (Theme.of(context).cardTheme.color)!;
    final canvasColor = Theme.of(context).canvasColor;
    final accent = Theme.of(context).accentColor;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('Histórico'),
            onTap: () => Modular.to.pushNamed(home.HISTORY_PAGE),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Atualizar dados'),
            onTap: () async {
              if (!(await _checkConnection(context))) return;
              controller.update();
            },
          ),
          Divider(height: 1.0),
          Observer(
            builder: (_) => ListTile(
              title: Text('Notificações do RDM'),
              trailing: CupertinoSlidingSegmentedControl<bool>(
                groupValue: controller.isBackgroundTaskActivated,
                onValueChanged: (v) => controller.activateBackgroundTask(v!),
                thumbColor: cardColor,
                backgroundColor: canvasColor,
                children: {
                  false: Icon(
                    Icons.power_settings_new,
                    color: controller.isBackgroundTaskActivated
                        ? Theme.of(_).canvasColor
                        : Theme.of(_).cardTheme.color,
                  ),
                  true: Icon(
                    Icons.power_settings_new,
                    color: controller.isBackgroundTaskActivated
                        ? accent
                        : canvasColor,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkConnection(BuildContext context) async {
    try {
      return await CheckConnection.checkConnection();
    } catch (_) {
      PlatformAlertDialog(
        title: 'Erro',
        content: Text('Problema de conexão!'),
        defaultActionText: 'OK',
      ).show(context);
      return false;
    }
  }
}

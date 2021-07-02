import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../routes.dart' as home;
import '../profile_controller.dart';
import 'color_picker_dialog.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final canvasColor = Theme.of(context).canvasColor;
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _themeSettings(canvasColor),
          Divider(height: 1.0),
          _accentSettings(context),
          Divider(height: 1.0),
          _notificationsRemover(),
          Divider(height: 1.0),
          ListTile(
            title: Text('Sobre o app'),
            onTap: () => Modular.to.pushNamed(home.ABOUT_PAGE),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Sair'),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  Observer _notificationsRemover() {
    return Observer(
      builder: (_) {
        if (controller.activeNotifications != 0)
          return Column(
            children: [
              ListTile(
                title: Text('Cancelar alertas pendentes'),
                trailing: Text('(${controller.activeNotifications})'),
                onTap: controller.cancelAllNotifications,
              ),
              Divider(height: 1.0),
            ],
          );
        else
          return Container(height: 0);
      },
    );
  }

  ListTile _accentSettings(BuildContext context) {
    return ListTile(
      title: Text('Cor de destaque'),
      onTap: () => _showColorPicker(context),
      trailing: Observer(builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Color(controller.accentCode),
            borderRadius: BorderRadius.circular(50),
          ),
          height: 30,
          width: 30,
        );
      }),
    );
  }

  ListTile _themeSettings(Color canvasColor) {
    return ListTile(
      title: Text('Tema'),
      trailing: Observer(builder: (_) {
        return CupertinoSlidingSegmentedControl<bool>(
          groupValue: controller.isDarkMode,
          onValueChanged: controller.setTheme,
          thumbColor: Theme.of(_).cardTheme.color!,
          backgroundColor: canvasColor,
          children: {
            false: Icon(Icons.wb_sunny_outlined),
            true: Icon(Icons.nightlight_round),
          },
        );
      }),
    );
  }

  Future<void> _showColorPicker(BuildContext context) async {
    if (MediaQuery.of(context).orientation == Orientation.landscape) return;

    final themes = Modular.get<CustomThemes>();

    List<Color> colors = controller.isDarkMode
        ? themes.darkAccentColors
        : themes.lightAccentColors;

    controller.setTempAccent(controller.accentCode);

    final result = await PlatformAlertDialog(
      title: 'Cor de destaque',
      content: ColorPickerDialog(
        colors: colors,
        initialColor: Color(controller.accentCode),
        onTap: (color) => controller.setTempAccent(color.value),
      ),
      defaultActionText: 'Confirmar',
      cancelActionText: 'Cancelar',
    ).show(context);

    if (result ?? false) controller.setAccent(controller.tempAccentCode);
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final result = await PlatformAlertDialog(
      title: 'Sair',
      content: Text('Tem certeza que quer sair?'),
      defaultActionText: 'Sair',
      cancelActionText: 'Cancelar',
    ).show(context);

    if (result ?? false) {
      await controller.signOut();
    }
  }
}

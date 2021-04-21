import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/themes/custom_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  const ProfilePage({Key? key, this.title = "Perfil"}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ModularState<ProfilePage, ProfileController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textTitle: 'Perfil',
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Observer(
      builder: (_) {
        if (controller.profile == null) {
          return LoadingIndicator(text: 'Carregando');
        } else {
          return _buildUserInfoSection();
        }
      },
    );
  }

  Widget _buildUserInfoSection() {
    final profile = controller.profile;

    return ListView(
      children: [
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(
                  '${profile?.name ?? ''}',
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Matrícula'),
                trailing: Text('${profile?.register ?? ''}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('C.R.A'),
                trailing: Text('${profile?.cra ?? ''}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('C.H. Acumulada'),
                trailing: Text('${profile?.cumulativeCh ?? 0}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Curso'),
                trailing: Text('${profile?.program ?? ''}'),
              ),
            ],
          ),
        ),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text('Ver Histórico'),
                onTap: controller.showHistory,
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Atualizar dados'),
                onTap: controller.update,
              ),
            ],
          ),
        ),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text('Tema'),
                trailing: Observer(builder: (_) {
                  return CupertinoSlidingSegmentedControl<bool>(
                    groupValue: controller.darkMode,
                    onValueChanged: controller.setTheme,
                    thumbColor: Theme.of(_).cardTheme.color!,
                    children: {
                      false: Icon(Icons.wb_sunny_outlined),
                      true: Icon(Icons.nightlight_round),
                    },
                  );
                }),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Cor de destaque'),
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
                onTap: _pickColor,
              ),
              Divider(height: 1.0),
              Observer(
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
              ),
              ListTile(
                title: Text('Sobre o app'),
                onTap: controller.showDetails,
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Sair'),
                onTap: _confirmSignOut,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmSignOut() async {
    final title = 'Sair';
    final content = 'Tem certeza que quer sair?';

    await showDialog(
      context: context,
      builder: (_) {
        final navigator = Navigator.of(_);
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => navigator.pop(false),
            ),
            TextButton(
              child: Text('Sair'),
              onPressed: () async {
                navigator.pop(true);
                await controller.logout();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _pickColor() async {
    if (!await _showRecommendedColorPicker()) await _showCustomColorPicker();
  }

  Future<void> _showCustomColorPicker() async {
    final h = MediaQuery.of(context).size.height * .6;
    controller.setTempAccent(controller.accentCode);

    await showDialog(
      context: context,
      builder: (_) {
        final navigator = Navigator.of(_);
        return AlertDialog(
          title: Observer(builder: (_) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cor:'),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(controller.tempAccentCode),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => navigator.pop(),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                controller.setAccent(controller.tempAccentCode);
                navigator.pop();
              },
            ),
          ],
          content: SingleChildScrollView(
            child: Observer(
              builder: (_) {
                return Container(
                  height: h,
                  child: MaterialPicker(
                    pickerColor: Color(controller.tempAccentCode),
                    onColorChanged: (color) {
                      controller.setTempAccent(color.value);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showRecommendedColorPicker() async {
    final h = MediaQuery.of(context).size.height * .3;

    final themes = Modular.get<CustomThemes>();
    final accent = Theme.of(context).accentColor;
    List<Color> colors = controller.darkMode
        ? themes.darkAccentColors
        : themes.lightAccentColors;

    if (!colors.contains(accent)) colors.add(accent);

    colors.sort(
      (a, b) => a.computeLuminance().compareTo(b.computeLuminance()),
    );

    if (controller.darkMode) colors = colors.reversed.toList();

    controller.setTempAccent(controller.accentCode);
    return await showDialog(
      context: context,
      builder: (_) {
        final navigator = Navigator.of(_);

        return AlertDialog(
          title: Text('Cor de destaque'),
          actions: [
            // TextButton(
            //   child: Text('Mais cores'),
            //   onPressed: () async => navigator.pop(false),
            // ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => navigator.pop(true),
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                controller.setAccent(controller.tempAccentCode);
                navigator.pop(true);
              },
            ),
          ],
          content: SingleChildScrollView(
            child: Observer(
              builder: (_) {
                return Container(
                  height: h,
                  child: BlockPicker(
                    availableColors: colors,
                    pickerColor: Color(controller.accentCode),
                    onColorChanged: (color) =>
                        controller.setTempAccent(color.value),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

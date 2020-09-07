import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/about_me/about_me_page.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class PreferencesPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final notify = Provider.of<NotificationsService>(context, listen: false);
      notify.cancelAllNotification();

      final database = Provider.of<Database>(context, listen: false);
      database.clearData();

      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar sair',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Sair',
      content: 'Tem certeza que quer sair?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Sair',
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  bool _isDark(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return database.isDarkMode;
  }

  Color _getCurrentColor(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return database.getColorTheme();
  }

  List<Color> _getColorsPicker(BuildContext context) {
    return [
      Colors.blueGrey,
      Color(0xFF505050),
      Color(0xFFCCCCCC),
      Colors.green,
      Colors.teal,
      Colors.pink,
      Colors.amberAccent,
      Colors.cyan,
      Colors.deepOrange,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.deepPurple,
      Colors.lightGreenAccent,
      Colors.indigo,
      Colors.purpleAccent,
      Colors.yellowAccent,
      Color(0xFFEE0000),
      Colors.lightBlue,
      Colors.brown,
      Color(0xFF00AA00),
    ];
  }

  Future<void> _setTheme(BuildContext context,
      {bool isDark, Color color}) async {
    final database = Provider.of<Database>(context, listen: false);
    if (isDark != null) await database.setDarkMode(isDark);
    if (color != null) database.setColorTheme(color);
  }

  void _pickColor(BuildContext context) {
    final dbContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: BlockPicker(
              availableColors: _getColorsPicker(dbContext),
              pickerColor: _getCurrentColor(dbContext),
              onColorChanged: (color) => _setTheme(dbContext, color: color),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(color: CustomThemes.accentColor),
        ),
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final darkMode = _isDark(context);

    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Modo escuro'),
                trailing: Switch(
                  value: darkMode,
                  onChanged: (val) => _setTheme(context, isDark: !darkMode),
                ),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Mudar cor de destaque'),
                onTap: () => _pickColor(context),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Sobre o aplicativo'),
                onTap: () async {
                  return await Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => AboutMePage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(
              'Sair',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () => _confirmSignOut(context),
          ),
        ),
      ],
    );
  }
}

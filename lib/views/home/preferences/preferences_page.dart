import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PreferencesPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
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

  void _setTheme(BuildContext context, bool isDark) {
    final database = Provider.of<Database>(context, listen: false);
    database.setDarkMode(isDark);
  }

  Future<void> _syncData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      await database.syncData();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar atualizar',
        exception: e,
      ).show(context);
    }
  }

  Widget _buildContents(BuildContext context) {
    final darkMode = _isDark(context);

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Modo escuro'),
            trailing: Switch(
              value: darkMode,
              onChanged: (val) => _setTheme(context, !darkMode),
            ),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Atualizar Informações'),
            onTap: () => _syncData(context),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Sair', style: TextStyle(fontSize: 18.0)),
            onTap: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildContents(context),
    );
  }
}

import 'package:cau3pb/models/models.dart';
import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class AccountPage extends StatelessWidget {
  Future<Profile> _getData(BuildContext context,
      {bool ignoreLocalData: false}) async {
    final database = Provider.of<Database>(context, listen: false);
    var profile;

    try {
      profile = await database.getProfileData(ignoreLocalData: ignoreLocalData);
    } on PlatformException catch (e) {
      throw PlatformException(code: 'error_network', message: e.message);
    }
    return profile;
  }

  Future<void> _syncData(BuildContext context) async {
    try {
      await _getData(context, ignoreLocalData: true);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar atualizar',
        exception: e,
      ).show(context);
    }
  }

  Widget _buildUserInfoSection(BuildContext context, Profile profile) {
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
                  '${profile.name}',
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Matrícula'),
                trailing: Text('${profile.register}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('C.R.A'),
                trailing: Text('${profile.cra}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('C.H. Acumulada'),
                trailing: Text('${profile.cumulativeCh}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Curso'),
                trailing: Text('${profile.program}'),
              ),
              Divider(height: 1.0),
              ListTile(
                title: Text('Sincronizar dados'),
                trailing: Icon(Icons.refresh),
                onTap: () => _syncData(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<Profile>(
            future: _getData(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return _buildUserInfoSection(context, user);
              } else if (snapshot.hasError) {
                return EmptyContent(
                  title: 'Algo deu errado',
                  message: snapshot.error.runtimeType == PlatformException
                      ? '${(snapshot.error as PlatformException).message}'
                      : snapshot.error.toString(),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20.0),
                      Text('Carregando ...'),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu perfil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              CupertinoPageRoute(
                fullscreenDialog: false,
                builder: (context) => PreferencesPage(),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }
}

import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _updating;
  static const _settingPageAd = AdUnitIds.settingPageAd;

  @override
  void initState() {
    super.initState();
    _updating = false;
  }

  Future<Profile> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    Profile profile;
    try {
      profile = await database.getProfileData();
    } on PlatformException catch (e) {
      throw PlatformException(code: 'error_network', message: e.message);
    }
    return profile;
  }

  Future<void> _syncData(BuildContext context) async {
    setState(() => _updating = true);
    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.getAllData(getLocalData: false);
      setState(() => _updating = false);
    } on PlatformException catch (e) {
      setState(() => _updating = false);

      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar atualizar',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meu perfil',
          style: TextStyle(color: CustomThemes.accentColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: CustomThemes.accentColor,
            ),
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
      body: Column(
        children: [
          Expanded(child: _buildContent(context)),
          CustomAdBanner(adUnitID: _settingPageAd),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<Profile>(
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
    );
  }

  Widget _buildUserInfoSection(BuildContext context, Profile profile) {
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.all(10),
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
            title: Text('Atualizar dados'),
            trailing: Icon(Icons.refresh, color: CustomThemes.accentColor),
            onTap: () => _updating ? null : _syncData(context),
          ),
        ),
      ],
    );
  }
}

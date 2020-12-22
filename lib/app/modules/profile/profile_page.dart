import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'profile_controller.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  const ProfilePage({Key key, this.title = "Perfil"}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ModularState<ProfilePage, ProfileController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
      floatingActionButton: Observer(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () => controller.setTheme(!controller.isDark),
          label: Text('Tema'),
          tooltip: 'Mudar Tema',
          icon: Icon(
            controller.isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          ),
        ),
      ),
    );
  }
}

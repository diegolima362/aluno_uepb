import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'reminders_controller.dart';

class RemindersPage extends StatefulWidget {
  final String title;

  const RemindersPage({Key key, this.title = "Lembretes"}) : super(key: key);

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState
    extends ModularState<RemindersPage, RemindersController> {
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => print('add reminder'),
        label: Text('Adicionar'),
        tooltip: 'Adicionar Lembrete',
        icon: Icon(Icons.add),
      ),
    );
  }
}

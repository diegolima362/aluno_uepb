import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'rdm_controller.dart';

class RdmPage extends StatefulWidget {
  final String title;

  const RdmPage({Key key, this.title = "RDM"}) : super(key: key);

  @override
  _RdmPageState createState() => _RdmPageState();
}

class _RdmPageState extends ModularState<RdmPage, RdmController> {
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
        onPressed: () => print('> update'),
        label: Text('Atualizar'),
        tooltip: 'Atualizar dados',
        icon: Icon(Icons.update_sharp),
      ),
    );
  }
}

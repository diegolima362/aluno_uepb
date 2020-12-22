import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_content_controller.dart';

class HomeContentPage extends StatefulWidget {
  final String title;

  const HomeContentPage({Key key, this.title = "HomeContent"})
      : super(key: key);

  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState
    extends ModularState<HomeContentPage, HomeContentController> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final portrait = height > width;
    final screenSize = MediaQuery.of(context).size;

    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => print('> show full schedule'),
        label: Text('Horário Completo'),
        tooltip: 'Mostrar Horário Completo',
        icon: Icon(Icons.calendar_today_sharp),
      ),
    );
  }
}

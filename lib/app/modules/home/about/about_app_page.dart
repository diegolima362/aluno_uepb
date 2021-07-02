import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutAppPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          _buildLogo(),
          ListTile(
            title: Text(
              'Aluno UEPB',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              'Versão 1.2.0',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: SizedBox()),
          Text(
            'Feito com ❤️ por Diego Lima\n' + '#Flutter',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    final colors = [
      Color(0xff1a1a1a),
      Color(0xffb30000),
      Color(0xffb3b3b3),
    ];

    return Container(
      height: 125,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colors[index],
            ),
          ),
        ),
      ),
    );
  }
}

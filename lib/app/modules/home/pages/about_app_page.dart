import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'Aluno UEPB',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                'Versão 1.1.0_b',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Image(image: AssetImage('images/icon.png')),
              height: 125,
            ),
            SizedBox(height: 20),
            Text(
              'Feito com ❤️ por Diego Lima\n' + '#Flutter',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              '© 2020-2021 362Devs',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

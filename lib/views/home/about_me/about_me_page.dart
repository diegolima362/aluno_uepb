import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:flutter/material.dart';

class AboutMePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage('images/icon.png'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Aplicativo não oficial para\n alunos da UEPB\n\n' + 'v1.0.0',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 100),
                Text(
                  'Feito com ❤️ por @diegolima_362\n' + '#Flutter',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

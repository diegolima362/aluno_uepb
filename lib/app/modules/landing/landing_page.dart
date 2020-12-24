import 'package:aluno_uepb/app/shared/components/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'landing_controller.dart';

class LandingPage extends StatefulWidget {
  final String title;

  const LandingPage({Key key, this.title = "Landing"}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends ModularState<LandingPage, LandingController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: SizedBox(height: 1)),
            Text(
              'Aplicativo companheiro para alunos da UEPB',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 20),
            CustomRaisedButton(
              child: Text('Entrar'),
              onPressed: controller.goToLogin,
              borderRadius: 20.0,
            ),
            Expanded(child: SizedBox(height: 1)),
            Center(
              child: Text(
                'Made with ❤️ by @diegolima_362',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

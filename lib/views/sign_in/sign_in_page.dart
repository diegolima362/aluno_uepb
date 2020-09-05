import 'package:flutter/material.dart';

import 'sign_in_button.dart';
import 'user_sign_in_page.dart';

class SignInPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    return SignInPage();
  }

  void _sigInWithRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => UserSignInPage(),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.height * 0.03,
        vertical: size.height * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: SizedBox()),
          Text(
            'Aplicativo não oficial para alunos da UEPB',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 40.0),
          SignInButton(
            text: 'Entrar',
            textColor: Colors.white,
            onPressed: () => _sigInWithRegister(context),
            borderRadius: 20.0,
          ),
          SizedBox(height: size.height * 0.2),
          Center(
            child: Text(
              'Made with ❤️ by @diegolima_362',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }
}

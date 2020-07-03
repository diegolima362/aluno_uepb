import 'package:erdm/app/sign_in/register_sign_in_page.dart';
import 'package:erdm/app/sign_in/sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    return SignInPage();
  }

  void _sigInWithRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => RegisterSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.45,
          ),
          Text(
            'Veja as aulas do dia, seus dados acadêmicos e adicione lembretes de atividades',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w100,
              fontSize: 24.0,
            ),
          ),
          SignInButton(
            text: 'Entrar',
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () => _sigInWithRegister(context),
            borderRadius: 25.0,
          ),
          Center(
            child: Text(
              'Made with 💜 by @diegolima362',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 10.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

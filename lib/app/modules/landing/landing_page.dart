import 'package:aluno_uepb/app/shared/components/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'components/delayed_animation.dart';
import 'landing_controller.dart';

class LandingPage extends StatefulWidget {
  final String title;

  const LandingPage({Key key, this.title = 'Landing'}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends ModularState<LandingPage, LandingController>
    with SingleTickerProviderStateMixin {
  //use 'controller' variable to access controller

  final delayedAmount = 100;
  final accent = Colors.white;
  final bgColor = Color(0xff141414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        brightness: Brightness.dark,
      ),
      backgroundColor: bgColor,
      body: Observer(
        builder: (context) {
          debugPrint('> LandingPage: isLogged = ${controller.isLogged}');
          debugPrint('> LandingPage: user = ${controller.user}');

          final showLoading =
              controller.user == null || (controller.user?.logged ?? false);

          if (showLoading) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          } else {
            return _buildContent();
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    final image = Image.asset('images/icon.png');
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          color: bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              DelayedAnimation(
                delay: delayedAmount,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: accent,
                  child: Container(
                    child: image,
                    height: 75,
                  ),
                ),
              ),
              SizedBox(height: height * .03),
              DelayedAnimation(
                delay: delayedAmount + 500,
                child: Text(
                  'Olá!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: accent,
                  ),
                ),
              ),
              DelayedAnimation(
                child: Text(
                  'Bom te ver por aqui!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: accent,
                  ),
                ),
                delay: delayedAmount + 1000,
              ),
              SizedBox(height: height * .1),
              DelayedAnimation(
                child: Text(
                  'Pronto pra ver',
                  style: TextStyle(fontSize: 18.0, color: accent),
                ),
                delay: delayedAmount + 1500,
              ),
              DelayedAnimation(
                child: Text(
                  'no que eu posso te ajudar?',
                  style: TextStyle(fontSize: 18.0, color: accent),
                ),
                delay: delayedAmount + 2000,
              ),
              SizedBox(height: height * .1),
              DelayedAnimation(
                child: Container(
                  width: 250,
                  height: 50,
                  child: CustomRaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 24,
                        color: accent,
                      ),
                    ),
                    color: bgColor,
                    onPressed: controller.goToLogin,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: accent),
                    ),
                  ),
                ),
                delay: delayedAmount + 2500,
              ),
              SizedBox(height: height * .05),
              DelayedAnimation(
                child: Text(
                  'Feito com ❤️ por Diego Lima',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: accent),
                ),
                delay: delayedAmount + 3000,
              ),
              SizedBox(height: height * .01),
            ],
          ),
        ),
      ),
    );
  }
}

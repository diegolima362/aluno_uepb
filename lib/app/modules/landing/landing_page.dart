import 'package:aluno_uepb/app/shared/auth/auth_controller.dart';
import 'package:aluno_uepb/app/shared/components/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../home/routes.dart' as home;
import '../routes.dart' as global;

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();

    authController = Modular.get<AuthController>();
    authController.status.observe((status) async {
      if (status.newValue == AuthStatus.loggedOn) {
        Modular.to.navigate(global.HOME + home.TODAY_SCHEDULE_PAGE);
      } else if (status.newValue == AuthStatus.loggedOut) {
        Modular.to.navigate(global.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingIndicator(text: 'Carregando'),
      ),
    );
  }
}

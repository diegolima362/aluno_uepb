import 'dart:async';

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

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      Duration(seconds: 3),
      () => Modular.to.navigate(global.LOGIN),
    );

    authController = Modular.get<AuthController>();
    authController.status.observe((status) => _checkStatus(status.newValue));
    authController.loadUser();
    _checkStatus(authController.status.value);
  }

  _checkStatus(AuthStatus? status) {
    if (status == AuthStatus.loggedOn) {
      _goToHome();
    } else if (status == AuthStatus.loggedOut) {
      _gotoLogin();
    }
  }

  _goToHome() {
    _timer?.cancel();
    Modular.to.navigate(global.HOME + home.TODAY_SCHEDULE_PAGE);
  }

  _gotoLogin() {
    _timer?.cancel();
    Modular.to.navigate(global.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: LoadingIndicator(text: 'Carregando'),
    );
  }
}

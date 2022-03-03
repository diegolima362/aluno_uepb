import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../stores/auth_store.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key) {
    final authStore = Modular.get<AuthStore>();

    authStore.checkLogin().whenComplete(() {
      if (authStore.isLogged) {
        Modular.to.navigate('/root/courses/');
      } else {
        Modular.to.navigate('/login/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

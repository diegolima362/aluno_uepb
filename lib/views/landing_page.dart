import 'package:aluno_uepb/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'sign_in/sign_in.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ValueListenableBuilder<Box>(
      valueListenable: auth.onAuthStateChanged,
      builder: (context, box, widget) {
        if (box.isEmpty) {
          return SignInPage.create(context);
        } else {
          return Provider<Database>(
            create: (_) => HiveDatabase(),
            child: Provider<NotificationsService>(
              create: (_) => LocalNotificationsService(),
              child: HomePage(),
            ),
          );
        }
      },
    );
  }
}

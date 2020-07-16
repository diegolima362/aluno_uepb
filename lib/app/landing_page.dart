import 'package:cau3pb/app/home_page.dart';
import 'package:cau3pb/app/sign_in/sign_in_page.dart';
import 'package:cau3pb/services/auth.dart';
import 'package:cau3pb/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

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
            child: HomePage(),
          );
        }
      },
    );
  }
}

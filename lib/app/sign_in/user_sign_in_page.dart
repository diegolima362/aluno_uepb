import 'package:cau3pb/app/sign_in/sign_in_form_change_notifier.dart';
import 'package:flutter/material.dart';

class UserSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: SingInFormChangeNotifier.create(context),
      ),
//      backgroundColor: Colors.white,
    );
  }
}

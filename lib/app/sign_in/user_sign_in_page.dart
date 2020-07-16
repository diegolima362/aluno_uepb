import 'package:cau3pb/app/sign_in/sign_in_form_change_notifier.dart';
import 'package:flutter/material.dart';

class RegisterSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3E206D),
        elevation: 0,
        brightness: Theme.of(context).brightness,
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

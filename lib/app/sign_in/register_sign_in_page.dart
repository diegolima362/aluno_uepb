import 'package:erdm/app/sign_in/sign_in_form_change_notifier.dart';
import 'package:flutter/material.dart';

class RegisterSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: SingInFormChangeNotifier.create(context),
      ),
      backgroundColor: Colors.white,
    );
  }
}

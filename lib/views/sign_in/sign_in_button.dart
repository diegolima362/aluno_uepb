import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    double borderRadius,
  })  : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
            ),
          ),
          color: color != null ? color : CustomThemes.accentColor,
          onPressed: onPressed,
          borderRadius: borderRadius,
        );
}

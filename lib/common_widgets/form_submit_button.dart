import 'package:erdm/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          height: 50.0,
          color: Color(0xFF3E206D),
          disabledColor: Color(0xFFf0E3FF),
          borderRadius: 25.0,
          onPressed: onPressed,
        );
}

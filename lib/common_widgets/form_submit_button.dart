import 'package:cau3pb/common_widgets/custom_raised_button.dart';
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
          color: Colors.black,
          disabledColor: Colors.black12,
          borderRadius: 20.0,
          onPressed: onPressed,
        );
}

import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({
    Key key,
    @required this.title,
    @required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

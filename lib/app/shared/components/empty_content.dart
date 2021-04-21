import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;
  final Color? titleColor;
  final Color? messageColor;

  const EmptyContent({
    Key? key,
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
    this.titleColor,
    this.messageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleColor = titleColor ?? Theme.of(context).accentColor;
    final _messageColor =
        messageColor ?? Theme.of(context).textTheme.headline6!.color;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 32.0,
              color: _titleColor,
            ),
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: _messageColor,
            ),
          ),
        ],
      ),
    );
  }
}

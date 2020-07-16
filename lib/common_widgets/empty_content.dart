import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  final String title;
  final String message;

  const EmptyContent({
    Key key,
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 32.0),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

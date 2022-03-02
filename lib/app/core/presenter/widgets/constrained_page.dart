import 'package:flutter/material.dart';

class ConstrainedPage extends StatelessWidget {
  final Widget child;

  const ConstrainedPage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        widthFactor: 0,
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Carregando',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

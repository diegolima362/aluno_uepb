import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: SizedBox()),
            CircularProgressIndicator(),
            const SizedBox(height: 40),
            Text(
              'Preparando seu primeiro acesso ...',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(child: SizedBox()),
            Text(
              'Estamos salvando seus dados offline\npara os próximos acessos',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

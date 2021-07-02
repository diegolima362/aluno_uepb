import 'package:aluno_uepb/app/shared/components/components.dart';
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
            LoadingIndicator(text: 'Carregando'),
            Expanded(child: SizedBox()),
            Text(
              'Salvando seus dados offline\npara os próximos acessos',
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

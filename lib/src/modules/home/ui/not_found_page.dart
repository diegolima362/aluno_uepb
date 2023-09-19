import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/domain/extensions/build_context_extensions.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Modular.to.navigate('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404',
              style: context.textTheme.displayLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Página não encontrada',
                style: context.textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

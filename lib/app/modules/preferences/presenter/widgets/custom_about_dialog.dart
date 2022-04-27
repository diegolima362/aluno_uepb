import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomAboutDialog extends StatelessWidget {
  const CustomAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const MyAppIcon(),
          Text(
            'v1.3.2',
            style: textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Feito com ❤ por Diego Lima',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Licenças'),
          onPressed: () {
            showLicensePage(
              context: context,
              applicationIcon: const MyAppIcon(),
              applicationLegalese: 'Aluno UEPB\n'
                  'Feito com ❤ por Diego Lima',
              applicationVersion: '1.3.2',
              applicationName: '',
            );
          },
        ),
        TextButton(
          child: const Text('Fechar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

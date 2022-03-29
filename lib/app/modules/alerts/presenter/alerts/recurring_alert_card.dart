import 'package:aluno_uepb/app/modules/courses/external/datasouces/adapters/drift/daos/daos.dart';
import 'package:flutter/material.dart';

import '../../../courses/presenter/widgets/widgets.dart';
import '../../domain/entities/entities.dart';

class RecurringAlertCard extends StatelessWidget {
  final RecurringAlertEntity alert;

  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const RecurringAlertCard({
    Key? key,
    required this.alert,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: textTheme.bodyLarge),
                Text(alert.time.format(context), style: textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  children: alert.days
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: CustomChip(
                              width: 50,
                              text: intToDay(e).substring(0, 3),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text('Editar'),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 4),
                TextButton(
                  child: const Text('Apagar'),
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aluno_uepb/app/core/domain/extensions/extensions.dart';
import 'package:aluno_uepb/app/modules/alerts/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final TaskReminderEntity reminder;

  final VoidCallback onEdit;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.onEdit,
    required this.onRemove,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.title, style: textTheme.bodyLarge),
                  Text(reminder.time.date, style: textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text(
                    reminder.body,
                    style: textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Divider(),
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
      ),
    );
  }
}

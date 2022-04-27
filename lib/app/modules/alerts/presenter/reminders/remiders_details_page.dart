import 'package:aluno_uepb/app/modules/courses/domain/usecases/get_course_by_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/domain/extensions/datetime_extensions.dart';
import '../../domain/entities/entities.dart';
import 'reminders_store.dart';

class ReminderDetailsPage extends HookWidget {
  final TaskReminderEntity reminder;

  const ReminderDetailsPage({Key? key, required this.reminder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final future = useMemoized(
      () => Modular.get<IGetCourseById>().call(reminder.course),
    );
    final course = useFuture(future);

    final store = Modular.get<RemindersStore>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Editar lembrete',
            icon: const Icon(Icons.edit),
            onPressed: () {
              Modular.to.pop();
              Modular.to.pushNamed(
                '/root/alerts/reminder/edit/',
                arguments: {'reminder': reminder, 'course': reminder.course},
                forRoot: true,
              );
            },
          ),
          IconButton(
            tooltip: 'Apagar lembrete',
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remover lembrete'),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: const Text('Remover'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );

              if (result ?? false) {
                await store.removeReminder(reminder.id);
                await store.getData(null);
                Modular.to.pop();
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
            child: course.data != null
                ? Text(
                    course.data?.fold(
                          (l) => '',
                          (r) => r.match((t) => t.name, () => ''),
                        ) ??
                        '',
                    style: textTheme.bodySmall,
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              reminder.title,
              style: textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(reminder.time.fullDate, style: textTheme.bodySmall),
          ),
          const Divider(height: 0),
          Expanded(
            child: Markdown(
              selectable: true,
              onTapLink: (a, b, c) {
                if (b != null) launchUrl(Uri.parse(b));
              },
              data: reminder.body,
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                [
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

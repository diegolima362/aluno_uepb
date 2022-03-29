import 'package:aluno_uepb/app/core/domain/extensions/extensions.dart';
import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:aluno_uepb/app/modules/courses/domain/entities/course_entity.dart';
import 'package:aluno_uepb/app/modules/courses/presenter/widgets/course_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

import '../../domain/entities/entities.dart';
import 'reminders_store.dart';

class ReminderEditPage extends HookWidget {
  final TaskReminderEntity? reminder;
  final String? courseId;

  const ReminderEditPage({
    Key? key,
    this.reminder,
    this.courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleController =
        useTextEditingController(text: reminder?.title ?? '');
    final bodyController = useTextEditingController(text: reminder?.body ?? '');

    final date = useState(reminder?.time ?? DateTime.now());

    final setAlert = useState(reminder?.notify ?? false);

    final course = useState<CourseEntity?>(null);
    final _courseId = useState(reminder?.course ?? courseId ?? '');

    final index = useState(0);

    final pickCourse = courseId == null;

    final lastIndex = pickCourse ? 3 : 2;

    return WillPopScope(
      onWillPop: () async {
        if (index.value == 0) {
          return true;
        } else {
          index.value--;
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(onPressed: () => Modular.to.pop()),
          title: Text(
            (reminder != null ? 'Editar' : 'Criar') + ' lembrete',
          ),
        ),
        body: Stepper(
          currentStep: index.value,
          controlsBuilder: (context, details) {
            return Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(details.stepIndex == 0 ? 'Cancelar' : 'Voltar'),
                    onPressed: details.onStepCancel,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: details.stepIndex == lastIndex
                        ? FilledButton(
                            context,
                            child: const Text('Salvar'),
                            onPressed: course.value == null && courseId == null
                                ? null
                                : details.onStepContinue,
                          )
                        : OutlinedButton(
                            child: const Text('Próximo'),
                            onPressed: details.onStepContinue,
                          )),
              ],
            );
          },
          onStepContinue: () async {
            if (index.value == lastIndex) {
              final title = titleController.value.text.isEmpty
                  ? 'Sem título'
                  : titleController.value.text;

              await createAlertFromState(
                title: title,
                subject: '',
                body: bodyController.value.text,
                course: course.value?.id ?? _courseId.value,
                setAlert: setAlert.value,
                date: date.value,
              );
              Modular.get<RemindersStore>().getData(courseId);
              Navigator.of(context).pop();
            } else {
              index.value++;
            }
          },
          onStepCancel: () {
            if (index.value == 0) {
              Navigator.of(context).pop();
            } else {
              index.value--;
            }
          },
          onStepTapped: (i) => index.value = i,
          steps: [
            Step(
              isActive: index.value >= 0,
              title: const Text('Informações'),
              state: index.value > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Título'),
                    controller: titleController,
                    validator: (text) =>
                        (text?.isEmpty ?? true) ? 'Informe um título' : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8.0),
                    child: Text(
                      'Anotações',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  MarkdownTextInput(
                    (value) => bodyController.text = value,
                    bodyController.text,
                    maxLines: null,
                    actions: MarkdownType.values,
                  ),
                ],
              ),
            ),
            if (courseId == null)
              Step(
                isActive: index.value >= 1,
                state: index.value > 1
                    ? (course.value != null
                        ? StepState.complete
                        : StepState.error)
                    : StepState.indexed,
                title: const Text('Curso'),
                content: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: CoursePicker(onSelect: (c) => course.value = c),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                  ),
                ),
              ),
            Step(
              isActive: index.value >= (pickCourse ? 2 : 1),
              state: index.value == lastIndex
                  ? StepState.complete
                  : StepState.indexed,
              title: const Text('Data'),
              content: RemiderDateStep(
                date: date,
                setAlert: setAlert,
              ),
            ),
            Step(
              isActive: index.value == lastIndex,
              title: const Text('Salvar'),
              content: ReminderSaveState(
                course: course.value?.name ?? '',
                title: titleController.text,
                date: date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createAlertFromState({
    required String course,
    required DateTime date,
    required String title,
    required String subject,
    required String body,
    required bool setAlert,
  }) async {
    final store = Modular.get<RemindersStore>();

    final _alert = TaskReminderEntity(
      id: reminder?.id ?? 0,
      course: course,
      title: title,
      subject: subject,
      body: body,
      time: date,
      notify: setAlert && date.isAfter(DateTime.now()),
      completed: false,
    );

    if (reminder != null) {
      await store.updateReminder(_alert);
    } else {
      await store.createReminder(_alert);
    }
  }
}

class ReminderSaveState extends StatelessWidget {
  const ReminderSaveState({
    Key? key,
    required this.course,
    required this.title,
    required this.date,
  }) : super(key: key);

  final String title;
  final String course;

  final ValueNotifier<DateTime> date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: course.isNotEmpty,
            child: StepTextItem(
              label: 'Curso',
              value: course,
            ),
          ),
          StepTextItem(
            label: 'Título',
            value: title.isNotEmpty ? title : 'Sem título',
          ),
          StepTextItem(
            label: 'Data',
            value: date.value.fullDate,
          ),
          StepTextItem(
            label: 'Horário',
            value: date.value.hours,
          ),
        ],
      ),
    );
  }
}

class RemiderDateStep extends StatelessWidget {
  const RemiderDateStep({
    Key? key,
    required this.date,
    required this.setAlert,
  }) : super(key: key);

  final ValueNotifier<DateTime> date;

  final ValueNotifier<bool> setAlert;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    useRootNavigator: false,
                    initialDate: date.value,
                    firstDate: date.value,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialEntryMode: DatePickerEntryMode.calendar,
                  );
                  if (picked != null) {
                    date.value = picked;
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(date.value.simpleDate.toUpperCase()),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    useRootNavigator: false,
                    initialEntryMode: TimePickerEntryMode.input,
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(date.value),
                  );

                  if (picked != null) {
                    date.value = picked.toDateTime(date.value);
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      Expanded(child: Text(date.value.hours)),
                      const Icon(Icons.alarm_sharp),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Visibility(
          visible: date.value.isAfter(DateTime.now()),
          child: CheckboxListTile(
            value: setAlert.value,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) => setAlert.value = value ?? false,
            activeColor: Theme.of(context).colorScheme.secondary,
            checkColor: Theme.of(context).colorScheme.onSecondary,
            title: Text(
              'Ativar alerta?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }
}

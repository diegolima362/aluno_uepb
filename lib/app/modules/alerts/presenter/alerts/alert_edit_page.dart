import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:aluno_uepb/app/modules/courses/presenter/widgets/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/entities.dart';
import 'alerts_store.dart';

const days = {
  'Seg': 1,
  'Ter': 2,
  'Qua': 3,
  'Qui': 4,
  'Sex': 5,
  'Sab': 6,
  'Dom': 7,
};

class AlertEditPage extends HookWidget {
  final RecurringAlertEntity? alert;
  final String course;

  const AlertEditPage({Key? key, this.alert, required this.course})
      : super(key: key);

  static const textStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: alert?.title ?? '');
    final alertDays = useMemoized(() {
      final list = List.generate(7, (index) => false);
      if (alert != null) {
        for (var d in alert!.days) {
          list[d - 1] = true;
        }
      }
      return list;
    });

    final actives = useState(alertDays);

    final time = useState(alert?.time ?? TimeOfDay.now());

    final index = useState(0);

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
            (alert != null ? 'Editar' : 'Criar') + ' alerta',
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
                    child: details.stepIndex == 2
                        ? FilledButton(
                            context,
                            child: const Text('Salvar'),
                            onPressed: actives.value.contains(true) ||
                                    (alert?.days.isNotEmpty ?? false)
                                ? details.onStepContinue
                                : null,
                          )
                        : OutlinedButton(
                            child: const Text('Próximo'),
                            onPressed: details.onStepContinue,
                          )),
              ],
            );
          },
          onStepContinue: () async {
            if (index.value == 2) {
              final title = titleController.value.text.isEmpty
                  ? 'Sem título'
                  : titleController.value.text;
              await createAlertFromState(
                title: title,
                course: course,
                time: time.value,
                days: actives.value
                    .mapWithIndex(
                        (selected, index) => selected ? index + 1 : -1)
                    .where((e) => e != -1)
                    .toList(),
              );
              // Modular.get<RemindersStore>().getData(courseId);
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
              title: const Text('Informações', style: textStyle),
              state: index.value > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    onEditingComplete: () => index.value++,
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (text) =>
                        (text?.isEmpty ?? true) ? 'Informe um título' : null,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        useRootNavigator: false,
                        initialEntryMode: TimePickerEntryMode.input,
                        context: context,
                        initialTime: time.value,
                      );

                      if (picked != null) {
                        time.value = picked;
                      }
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(child: Text(time.value.format(context))),
                          const Icon(Icons.alarm_sharp),
                        ],
                      ),
                      margin: const EdgeInsets.only(top: 24, bottom: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Step(
              isActive: index.value >= 1,
              state: index.value > 1 ? StepState.complete : StepState.indexed,
              title: const Text('Dias', style: textStyle),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: days.entries
                      .map(
                        (e) => CustomChip(
                          text: e.key[0],
                          width: 30,
                          height: 30,
                          active: actives.value[e.value - 1],
                          onPressed: () {
                            final index = e.value - 1;
                            actives.value[index] = !actives.value[index];
                            actives.value = [...actives.value];
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Step(
              isActive: index.value >= 2,
              title: const Text('Salvar', style: textStyle),
              state: index.value > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StepTextItem(
                    label: 'Título',
                    value: titleController.value.text.isNotEmpty
                        ? titleController.value.text
                        : 'Sem título',
                  ),
                  StepTextItem(
                    label: 'Horário',
                    value: time.value.format(context),
                  ),
                  StepTextItem(
                    label: 'Dias',
                    value: days.entries
                        .where((e) => actives.value[e.value - 1])
                        .fold(
                          '',
                          (a, b) => "$a${a.isEmpty ? '' : ','} ${b.key}",
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Unit> createAlertFromState({
    required String course,
    required TimeOfDay time,
    required List<int> days,
    required String title,
  }) async {
    final store = Modular.get<RecurringAlertsStore>();

    final _alert = RecurringAlertEntity(
      id: alert?.id ?? 0,
      course: course,
      title: title,
      days: days,
      time: time,
    );

    if (alert != null) {
      await store.updateAlert(_alert);
      store.getData(course);
    } else {
      await store.createAlert(_alert);
      store.getData(course);
    }

    return unit;
  }
}

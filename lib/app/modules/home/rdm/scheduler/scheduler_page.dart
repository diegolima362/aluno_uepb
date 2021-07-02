import 'package:aluno_uepb/app/modules/home/rdm/details/rdm_details_controller.dart';
import 'package:aluno_uepb/app/modules/home/routes.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'scheduler_controller.dart';

class SchedulerPage extends StatefulWidget {
  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState
    extends ModularState<SchedulerPage, SchedulerController> {
  late TextEditingController _titleController;
  late FocusNode _titleFocus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Adicionar alerta',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(8),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WeekDaySelector(controller: controller),
                _buildTitle(),
                SizedBox(height: 10),
                Observer(builder: (_) {
                  return InputDropdown(
                    labelText: 'Horário',
                    valueText: controller.dueTime.format(context),
                    onPressed: _selectTime,
                  );
                }),
                SizedBox(height: 10),
                SaveButton(onSave: () async {
                  await controller.scheduleReminder();
                  await Modular.get<RDMDetailsController>().loadData();
                  Modular.to.popAndPushNamed(
                    COURSE_DETAILS,
                    arguments: controller.course,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocus.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller.setDueTime(TimeOfDay.now());
    controller.setTitle('');

    _titleController = TextEditingController(text: controller.title);
    _titleFocus = FocusNode();
  }

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLines: null,
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Título',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      onChanged: controller.setTitle,
      focusNode: _titleFocus,
    );
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      cancelText: 'Cancelar',
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: controller.dueTime,
      helpText: 'Horário de entrega',
    );

    if (pickedTime != null && pickedTime != controller.dueTime) {
      controller.setDueTime(pickedTime);
    }
  }
}

class WeekDaySelector extends StatelessWidget {
  const WeekDaySelector({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SchedulerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.weekDaysMap.entries.map((d) {
            return Observer(
              builder: (_) {
                final active = controller.selectedDays[d.key];
                return SelectableItem(
                  active: active,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  onTap: () => controller.setDay(d.key),
                  text: d.value[0],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

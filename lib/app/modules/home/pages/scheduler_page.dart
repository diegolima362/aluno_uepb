import 'package:aluno_uepb/app/shared/components/custom_raised_button.dart';
import 'package:aluno_uepb/app/shared/components/input_dropdown.dart';
import 'package:aluno_uepb/app/shared/components/selectable_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../rdm/details/details_controller.dart';

class SchedulerPage extends StatefulWidget {
  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState
    extends ModularState<SchedulerPage, DetailsController> {
  late TextEditingController _titleController;
  late FocusNode _titleFocus;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).accentColor;
    final h = MediaQuery.of(context).size.height * .6;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar alerta',
          style: TextStyle(
            color: accent,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 30,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...controller.weekDaysMap.entries.map((d) {
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
                        }).toList()
                      ],
                    ),
                  ),
                ),
                _buildTitle(),
                InputDropdown(
                  labelText: 'Horário',
                  valueText: controller.dueTime.format(context),
                  onPressed: _selectTime,
                ),
                CustomRaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(color: accent),
                  ),
                  color: Theme.of(context).cardColor,
                  child: Text('Salvar'),
                  onPressed: () {
                    controller.scheduleReminder();
                    Modular.to.pop(true);
                  },
                ),
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

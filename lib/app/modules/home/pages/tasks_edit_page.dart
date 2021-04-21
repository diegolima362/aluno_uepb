import 'package:aluno_uepb/app/modules/rdm/components/course_picker.dart';
import 'package:aluno_uepb/app/shared/components/input_dropdown.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../reminders/tasks/edit/edit_controller.dart';

class TaskEditPage extends StatefulWidget {
  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends ModularState<TaskEditPage, EditController> {
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  FocusNode _textFocus = FocusNode();
  FocusNode _titleFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Observer(
            builder: (_) => TextButton(
              child: Text(
                'Salvar',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () => controller.save(),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10.0),
                _buildTitle(),
                const SizedBox(height: 10.0),
                _buildText(),
                const SizedBox(height: 20.0),
                if (controller.task?.courseId == null)
                  Observer(builder: (_) => _buildCourse()),
                const SizedBox(height: 20.0),
                Observer(builder: (_) => _buildFinalDate()),
                const SizedBox(height: 20.0),
                Observer(builder: (_) => _buildSetReminder()),
                Observer(builder: (_) => _buildMarkAsNotDone()),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    _textFocus.dispose();
    _titleFocus.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _titleController = TextEditingController(text: controller.title);
    _textController = TextEditingController(text: controller.text);

    super.initState();
  }

  Widget _buildCourse() {
    return controller.isLoading
        ? Text('Carregando')
        : Column(
            children: [
              Container(
                height: 50,
                child: CoursePicker(
                  selectCourse: controller.setCourse,
                  courses: controller.courses,
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            ],
          );
  }

  Widget _buildFinalDate() {
    final valueStyle = Theme.of(context).textTheme.headline6;

    return Row(
      children: [
        Expanded(
          child: InputDropdown(
            labelText: 'Data',
            valueText: Format.simpleDate(controller.dueDate),
            valueStyle: valueStyle,
            onPressed: _selectDate,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: InputDropdown(
            labelText: 'Horário',
            valueText: controller.dueTime.format(context),
            valueStyle: valueStyle,
            onPressed: _selectTime,
          ),
        ),
      ],
    );
  }

  Widget _buildMarkAsNotDone() {
    if (!controller.isCompleted)
      return Container(height: 0);
    else
      return CheckboxListTile(
        checkColor: Theme.of(context).canvasColor,
        activeColor: Theme.of(context).accentColor,
        contentPadding: EdgeInsets.all(0),
        title: Text(
          'Marcar como não concluida',
          style: TextStyle(fontSize: 20.0),
        ),
        onChanged: controller.setUndone,
        value: controller.undone,
      );
  }

  Widget _buildSetReminder() {
    return CheckboxListTile(
      activeColor: Theme.of(context).accentColor,
      checkColor: Theme.of(context).canvasColor,
      contentPadding: EdgeInsets.all(0),
      title: Text(
        'Criar alerta',
        style: TextStyle(fontSize: 20.0),
      ),
      value: controller.reminder,
      onChanged: controller.setReminder,
    );
  }

  Widget _buildText() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLines: null,
      controller: _textController,
      focusNode: _textFocus,
      decoration: InputDecoration(
        labelText: 'Comentários',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      onChanged: controller.setText,
    );
  }

  Widget _buildTitle() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      maxLines: null,
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Nome',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      onChanged: controller.setTitle,
      focusNode: _titleFocus,
      onEditingComplete: () {
        final newFocus = controller.title.isNotEmpty ? _textFocus : _titleFocus;
        FocusScope.of(context).requestFocus(newFocus);
      },
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: 'Data de entrega',
      cancelText: 'Cancelar',
    );

    if (pickedDate != null && pickedDate != controller.dueDate) {
      controller.setDueDate(pickedDate);
    }
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

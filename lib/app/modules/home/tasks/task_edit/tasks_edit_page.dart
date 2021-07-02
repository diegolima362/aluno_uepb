import 'package:aluno_uepb/app/modules/home/routes.dart';
import 'package:aluno_uepb/app/modules/home/tasks/tasks_controller.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'tasks_edit_controller.dart';

class TaskEditPage extends StatefulWidget {
  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState
    extends ModularState<TaskEditPage, TasksEditController> {
  late final TextEditingController _textController;
  late final TextEditingController _titleController;
  FocusNode _textFocus = FocusNode();
  FocusNode _titleFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Observer(
        builder: (context) {
          if (controller.isLoading) {
            return LoadingIndicator(text: 'Carregando');
          } else if (controller.hasError) {
            return EmptyContent(
              title: 'Nada por aqui',
              message: 'Erro ao obter os dados!',
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(2),
            child: Card(
              elevation: 2.0,
              margin: EdgeInsets.all(4),
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
                    Observer(builder: (_) => _buildCourse()),
                    const SizedBox(height: 20.0),
                    Observer(builder: (_) => _buildFinalDate()),
                    const SizedBox(height: 20.0),
                    Observer(builder: (_) => _buildSetReminder()),
                    const SizedBox(height: 20.0),
                    SaveButton(
                      onSave: () async {
                        await controller.save();
                        await Modular.get<TasksController>().loadData();
                        Modular.to.navigate(TASKS_PAGE);
                      },
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          );
        },
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

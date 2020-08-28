import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/all_tasks/course_picker.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({
    @required this.database,
    @required this.course,
    @required this.notificationsService,
    this.task,
    this.courses,
  });

  final Course course;
  final List<Course> courses;
  final Task task;
  final Database database;
  final NotificationsService notificationsService;

  static Future<void> show({
    BuildContext context,
    Database database,
    NotificationsService notificationsService,
    Course course,
    Task task,
  }) async {
    final courses = await database.getCoursesData();
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          database: database,
          course: course,
          notificationsService: notificationsService,
          courses: courses,
          task: task,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  DateTime _finalDate;
  TimeOfDay _finalTime;
  String _title;
  String _comment;
  Course _course;
  bool _checked;
  bool _done;

  @override
  void initState() {
    final date = widget.task?.date ?? DateTime.now();

    _finalDate = DateTime(date.year, date.month, date.day);
    _finalTime = TimeOfDay.fromDateTime(date);
    _course = widget.course;
    _title = widget.task?.title ?? '';
    _comment = widget.task?.comment ?? '';
    _checked = widget.task?.setReminder ?? false;
    _done = widget.task?.isCompleted == true ? false : true;
    super.initState();
  }

  Task _taskFromState() {
    final date = DateTime(_finalDate.year, _finalDate.month, _finalDate.day,
        _finalTime.hour, _finalTime.minute);

    final id = widget.task?.id ?? documentIdFromCurrentDate();

    return Task(
      id: id,
      title: _title.isNotEmpty ? _title : 'Sem titulo',
      courseId: _course.id,
      courseTitle: _course.title,
      date: date,
      comment: _comment,
      setReminder: _checked,
      isCompleted: !_done,
    );
  }

  Future<void> _setTaskAndDismiss(BuildContext context) async {
    try {
      final task = _taskFromState();
      await widget.database.addTask(task);

      if (_checked) {
        widget.notificationsService.setListenerForLowerVersions((_) {});
        widget.notificationsService.setOnNotificationClick((_) {});
        widget.notificationsService.scheduleNotification(NotificationModel(
          id: int.parse(task.id),
          title: 'Entrega de atividade',
          body: task.title,
          dateTime: task.date,
          payload: task.toString(),
        ));
      } else {
        widget.notificationsService.cancelNotification(int.parse(task.id));
      }

      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação Falhou',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: CustomThemes.accentColor),
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            disabledTextColor: Theme.of(context).appBarTheme.color,
            textColor: CustomThemes.accentColor,
            child: Text(
              'Salvar',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed:
                _course != null ? () => _setTaskAndDismiss(context) : null,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(),
                const SizedBox(height: 10.0),
                _buildComment(),
                const SizedBox(height: 10.0),
                if (widget.course == null) _buildCourse(),
                const SizedBox(height: 8.0),
                _buildFinalDate(),
                const SizedBox(height: 20.0),
                _buildSetReminder(),
                if (widget.task?.isCompleted ?? false) _buildMarkAsNotDone(),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _title),
      decoration: InputDecoration(
        labelText: 'Nome',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      maxLines: 1,
      onChanged: (title) => _title = title,
    );
  }

  Widget _buildCourse() {
    return CoursePicker(
      selectCourse: (course) => setState(() => _course = course),
      courses: widget.courses,
    );
  }

  Widget _buildFinalDate() {
    return DateTimePicker(
      labelText: 'Entrega',
      selectedDate: _finalDate,
      selectedTime: _finalTime,
      selectDate: (date) => setState(() => _finalDate = date),
      selectTime: (time) => setState(() => _finalTime = time),
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 300,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Anotações',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      onChanged: (comment) => _comment = comment,
    );
  }

  Widget _buildSetReminder() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        'Definir lembrete',
        style: TextStyle(fontSize: 20.0),
      ),
      onChanged: ((value) => setState(() => _checked = value)),
      value: _checked,
    );
  }

  Widget _buildMarkAsNotDone() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        'Marcar como não concluida',
        style: TextStyle(fontSize: 20.0),
      ),
      onChanged: ((value) => setState(() => _done = value)),
      value: _done,
    );
  }
}

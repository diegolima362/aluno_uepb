import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/all_tasks/course_picker.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  FirebaseAnalytics analytics;
  DateTime _finalDate;
  TimeOfDay _finalTime;
  String _title;
  String _comment;
  Course _course;
  bool _checked;
  bool _haveChanged = false;
  bool _done;

  @override
  void initState() {
    analytics = Provider.of<FirebaseAnalytics>(context, listen: false);
    analytics.setCurrentScreen(screenName: '/edit_task_page');

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

  Future<void> _sendAnalyticsEvent(Task task) async {
    await analytics.logEvent(
      name: 'task_created',
      parameters: <String, dynamic>{
        'setedTitle': task.title != 'Sem titulo',
        'setedComments': task.comment?.isNotEmpty,
        'setedReminder': task.setReminder,
      },
    );
  }

  Future<void> _setTaskAndDismiss(BuildContext context) async {
    try {
      final task = _taskFromState();
      await widget.database.addTask(task);

      if (_haveChanged) {
        if (_checked) {
          _setNotification(task);
        } else {
          widget.notificationsService.cancelNotification(int.parse(task.id));
        }
      }

      _sendAnalyticsEvent(task);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operação Falhou',
        exception: e,
      ).show(context);
    }
  }

  void _setNotification(Task task) {
    widget.notificationsService.setListenerForLowerVersions((_) {});
    widget.notificationsService.setOnNotificationClick((_) {});
    widget.notificationsService.scheduleNotification(NotificationModel(
      id: int.parse(task.id),
      title: task.title,
      body: task.courseTitle + '.',
      dateTime: task.date,
      payload: '${Format.date(task.date)} ${Format.hours(task.date)}',
    ));
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
          margin: EdgeInsets.all(10),
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
        labelText: 'Título',
        alignLabelWithHint: true,
      ),
      style: TextStyle(fontSize: 20.0),
      maxLines: 1,
      onChanged: (title) => _title = title,
    );
  }

  Widget _buildCourse() {
    return Column(
      children: [
        CoursePicker(
          selectCourse: (course) => setState(() => _course = course),
          courses: widget.courses,
        ),
        Divider(
          color: CustomThemes.isDark
              ? CustomThemes.anotherWhite
              : CustomThemes.anotherBlack,
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
            valueText: Format.date(_finalDate),
            valueStyle: valueStyle,
            onPressed: () => _selectDate(),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: InputDropdown(
            labelText: 'Horário',
            valueText: _finalTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _finalDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != _finalDate) {
      setState(() => _finalDate = pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final accent = CustomThemes.accentColor;

    if (CustomThemes.isDark) {
      widget.database.setColorTheme(Colors.white);
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _finalTime,
    );

    if (pickedTime != null && pickedTime != _finalTime) {
      setState(() => _finalTime = pickedTime);
    }

    widget.database.setColorTheme(accent);
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
        'Criar lembrete',
        style: TextStyle(fontSize: 20.0),
      ),
      value: _checked,
      onChanged: ((value) => setState(() {
            _haveChanged = true;
            _checked = value;
          })),
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

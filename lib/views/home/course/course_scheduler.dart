import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekday_selector/weekday_selector.dart';

final Map<int, String> _weekDaysMap = {
  0: 'Dom',
  1: 'Seg',
  2: 'Ter',
  3: 'Qua',
  4: 'Qui',
  5: 'Sex',
  6: 'Sab',
};

class CourseScheduler extends StatefulWidget {
  const CourseScheduler({
    @required this.database,
    @required this.course,
    @required this.notificationsService,
    this.courses,
  });

  final Course course;
  final List<Course> courses;
  final Database database;
  final NotificationsService notificationsService;

  static Future<void> show({
    BuildContext context,
    Database database,
    NotificationsService notificationsService,
    Course course,
  }) async {
    final courses = await database.getCoursesData();
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => CourseScheduler(
          database: database,
          course: course,
          notificationsService: notificationsService,
          courses: courses,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<CourseScheduler> {
  DateTime _finalDate;
  TimeOfDay _selectedTime;
  Course _course;
  String _title;
  final List<bool> _selectedDays = List.filled(7, false);

  @override
  void initState() {
    _finalDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _course = widget.course;
    _title = 'Inicio da aula';
    super.initState();
  }

  Future<void> _setTaskAndDismiss(BuildContext context) async {
    for (int i = 0; i < _selectedDays.length; i++) {
      if (_selectedDays[i]) {
        final date = DateTime(
          _finalDate.year,
          _finalDate.month,
          i,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        try {
          widget.notificationsService.setListenerForLowerVersions((_){});
          widget.notificationsService.setOnNotificationClick((_){});
          widget.notificationsService.showWeeklyAtDayTime(
            NotificationModel(
              id: date.hashCode,
              title: _title,
              body: _course.title,
              weekDay: i,
              dateTime: date,
              payload: '${_weekDaysMap[i]} ${Format.hours(date)}',
            ),
          );
        } on PlatformException catch (e) {
          PlatformExceptionAlertDialog(
            title: 'Operação Falhou',
            exception: e,
          ).show(context);
        }
      }
    }
    Navigator.of(context).pop();
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
                _buildReminder(),
                const SizedBox(height: 20.0),
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

  Widget _buildReminder() {
    final valueStyle = Theme.of(context).textTheme.headline6;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _selectWeekDay(),
          SizedBox(height: 12.0),
          InputDropdown(
            labelText: 'Horário',
            valueText: _selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  Widget _selectWeekDay() {
    return WeekdaySelector(
      shortWeekdays: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],
      onChanged: (int day) {
        setState(() {
          final index = day % 7;
          _selectedDays[index] = !_selectedDays[index];
        });
      },
      values: _selectedDays,
    );
  }
}

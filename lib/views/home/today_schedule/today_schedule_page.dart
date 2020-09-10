import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/course_info/course_info_page.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class TodaySchedulePage extends StatelessWidget {
  Future<List<Course>> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: true);
    List<Course> courses;

    try {
      courses = await database.getCoursesData();
    } on PlatformException catch (e) {
      throw PlatformException(
          code: 'error_get_courses_data', message: e.message);
    }

    return courses;
  }

  List<Course> _todayClassesList(List<Course> items) {
    final today = DateTime.now().weekday;

    final List<Course> todayClasses = items
        .where((e) => e.schedule.map((e) => e.weekDay).toList().contains(today))
        .toList();

    todayClasses.sort(
        (a, b) => a.startTimeAtDay(today).compareTo(b.startTimeAtDay(today)));

    return todayClasses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 100,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Aulas de Hoje',
            style: TextStyle(
              fontSize: 32.0,
              color: CustomThemes.accentColor,
            ),
          ),
          subtitle: Text(
            DateFormat('MMMEd', 'pt_Br').format(DateTime.now()),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildContent(context)),
          _buildButton(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(
        width: 2,
        color: CustomThemes.accentColor,
      ),
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute(
          fullscreenDialog: false,
          builder: (context) => FullSchedulePage(),
        ),
      ),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        'Horário completo',
        style: TextStyle(fontSize: 14.0, color: CustomThemes.accentColor),
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FutureBuilder<List<Course>>(
      future: _getData(context),
      builder: (context, snapshot) {
        return ListItemsBuilder(
          emptyTitle: 'Nada por aqui',
          emptyMessage: 'Você não tem aulas hoje!',
          errorMessage: 'Tivemos um problema',
          itemBuilder: (context, course) => CourseInfoCard(
            course: course,
            weekDay: DateTime.now().weekday,
            onTap: () => CourseInfoPage.show(
              context: context,
              course: course,
            ),
          ),
          filter: _todayClassesList,
          snapshot: snapshot,
        );
      },
    );
  }
}

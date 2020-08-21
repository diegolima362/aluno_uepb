import 'package:cau3pb/models/models.dart';
import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../home.dart';
import 'course_full_info_card.dart';

class AllCoursesPage extends StatelessWidget {
  Future<List<Course>> _getData(BuildContext context,
      {bool ignoreLocalData: false}) async {
    final database = Provider.of<Database>(context, listen: false);
    List<Course> courses;

    try {
      courses = await database.getCoursesData(ignoreLocalData: ignoreLocalData);
    } on PlatformException catch (e) {
      throw PlatformException(
          code: 'error_get_courses_data', message: e.message);
    }

    courses.sort((a, b) => a.title.compareTo(b.title));
    return courses;
  }

  Future<void> _syncData(BuildContext context) async {
    try {
      await _getData(context, ignoreLocalData: true);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar atualizar',
        exception: e,
      ).show(context);
    }
  }

  void _print(BuildContext context, Course course) {
    print(course);
  }

  Widget _buildContents(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FutureBuilder<List<Course>>(
            future: _getData(context),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(0),
                child: ListItemsBuilder(
                  itemBuilder: (context, course) => CourseFullInfoCard(
                    course: course,
                    onTap: () => _print(context, course),
                  ),
                  snapshot: snapshot,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Disciplinas'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async => await _syncData(context),
            )
          ],
          elevation: 0,
        ),
        body: _buildContents(context),
      ),
    );
  }
}

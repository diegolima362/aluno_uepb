import 'package:aluno_uepb/models/models.dart';
import 'package:aluno_uepb/services/services.dart';
import 'package:aluno_uepb/themes/custom_themes.dart';
import 'package:aluno_uepb/views/home/course_info/course_info_page.dart';
import 'package:aluno_uepb/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'course_full_info_card.dart';

class AllCoursesPage extends StatefulWidget {
  @override
  _AllCoursesPageState createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Future<List<Course>> _getData(BuildContext context,
      {bool ignoreLocalData: false}) async {
    final database = Provider.of<Database>(context, listen: false);
    List<Course> courses;

    try {
      courses = await database.getCoursesData(ignoreLocalData: ignoreLocalData);
    } on PlatformException catch (e) {
      throw PlatformException(
          code: 'error_get_courses_data', message: e.message);
    } catch (e) {
      print(e);
    }

    courses.sort((a, b) => a.title.compareTo(b.title));
    return courses;
  }

  Widget _buildContents(BuildContext context) {
    if (isLoading)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Atualizando ... ',
              style: TextStyle(
                color: CustomThemes.accentColor,
                fontSize: 16,
              ),
            )
          ],
        ),
      );

    return FutureBuilder<List<Course>>(
      future: _getData(context),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: ListItemsBuilder(
            snapshot: snapshot,
            itemBuilder: (context, course) => CourseFullInfoCard(
              course: course,
              onTap: () => CourseInfoPage.show(
                context: context,
                course: course,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Disciplinas',
            style: TextStyle(color: CustomThemes.accentColor),
          ),
        ),
        body: _buildContents(context),
      ),
    );
  }
}

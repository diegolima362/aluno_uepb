import 'package:erdm/app/home/course_list_card.dart';
import 'package:erdm/app/home/course_list_filter.dart';
import 'package:erdm/common_widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:erdm/app/home/list_items_builder.dart';
import 'package:erdm/common_widgets/platform_alert_dialog.dart';
import 'package:erdm/models/course.dart';
import 'package:erdm/services/auth.dart';
import 'package:erdm/services/database.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar entrar',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Sair',
      content: 'Tem certeza que quer sair?',
      cancelActionText: 'Cancelar',
      defaultActionText: 'Sair',
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<Box> _getData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final box = await database.getLocalData();

    if (box.isNotEmpty) return box;

    try {
      database.getRemoteData();
    } catch (e) {
      rethrow;
    }

    return box;
  }

  Future<void> _clearData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.clearData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        actions: <Widget>[
          FlatButton(
            child: Text('Sair',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _clearData(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Box>(
      valueListenable: database.coursesStream(),
      builder: (context, box, widget) {
        if (box.isEmpty) {
          try {
            _getData(context);
          } catch (e) {
            PlatformAlertDialog(
              title: 'Erro ao conectar ao controle academico',
              content: e.message,
              defaultActionText: 'OK',
            ).show(context);
          }
        }
        return Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Text(
                'Aulas de Hoje',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32.0,
                ),
              ),
              Text(DateFormat('yMMMMEEEEd', 'pt_Br').format(DateTime.now())),
              SizedBox(height: size.height * 0.03),
              Expanded(
                child: ListItemsBuilder(
                  box: box,
                  boxName: 'courses',
                  itemBuilder: (context, map) => CourseListCard(
                    course: Course.fromMap(map),
                    onTap: () => _printa(context, map),
                  ),
                  filter: CourseListFilter.todayClassesList,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _printa(BuildContext context, Map course) {
    print(Course.fromMap(course).title);
  }
}

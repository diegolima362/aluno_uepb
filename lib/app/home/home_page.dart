import 'package:erdm/app/home/course_list_card.dart';
import 'package:erdm/app/home/course_list_filter.dart';
import 'package:erdm/app/home/list_items_builder.dart';
import 'package:erdm/common_widgets/platform_alert_dialog.dart';
import 'package:erdm/common_widgets/platform_exception_alert_dialog.dart';
import 'package:erdm/models/course.dart';
import 'package:erdm/services/auth.dart';
import 'package:erdm/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    print('> try to get local data');
    final box = await database.getLocalData();

    print('> checking local data');
    if (box.isNotEmpty) {
      print('> local data found');
      return box;
    }

    print('> no local data found');

    try {
      print('> try to get remote data');

      await database.getRemoteData();
    } catch (e) {
      rethrow;
    }

    print('> no errors, returning box');
    return box;
  }

  Future<void> _clearData(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.clearData();
  }

  void _printa(BuildContext context, Map course) {
    print(Course.fromMap(course).title);
  }

  List<Widget> _buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return [
      ListTile(
        contentPadding: EdgeInsets.all(4.0),
        title: Text(
          'Aulas de Hoje',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 32.0,
          ),
        ),
        subtitle: Text(
          DateFormat('yMMMMEEEEd', 'pt_Br').format(DateTime.now()),
        ),
      ),
      SizedBox(height: size.height * 0.03),
    ];
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

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
              ..._buildHeader(context),
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

  List<Widget> _buildActions(BuildContext context) {
    return [
      FlatButton(
        child: Text('Sair',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            )),
        onPressed: () => _confirmSignOut(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
        actions: _buildActions(context),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFCCCCCC),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
          color: Color(0xFFEEEEEE),
        ),
        child: _buildContents(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => _getData(context),
      ),
    );
  }
}

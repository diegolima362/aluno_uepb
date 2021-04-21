import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RDMDetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState
    extends ModularState<RDMDetailsPage, RDMDetailsController> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      floatingActionButton: Observer(builder: (_) => _buildFAB()),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildDetails(),
            SizedBox(height: 50),
            Observer(builder: (_) => _buildTasks()),
            SizedBox(height: 20),
            Observer(builder: (_) => _buildReminders()),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _handleScroll();
  }

  Widget _buildDetails() {
    final c = controller.course;
    // final h = MediaQuery.of(context).size.height;
    // final w = MediaQuery.of(context).size.width;
    // final portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        Container(
          child: CourseFullInfoCard(
            course: c,
            context: context,
            elevation: 0,
            color: Theme.of(context).canvasColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    final extended = controller.extended;

    return CustomFAB(
      onPressed: () async => await controller.showScheduler(),
      tooltip: 'Adicionar alerta',
      label: 'Adicionar',
      extended: extended,
      icon: Icon(Icons.add_alarm_outlined),
    );
  }

  Widget _buildReminders() {
    final _height = MediaQuery.of(context).size.height;

    if (!controller.hasReminders) {
      return SizedBox(height: _height * .03);
    } else {
      final _reminders = controller.reminders;

      return Column(
        children: [
          _header('Alertas'),
          Container(
            height: _height * .2,
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                final n = _reminders[index];

                return NotificationInfoCard(
                  notification: n,
                  onDelete: () async => await controller.deleteReminder(n),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTasks() {
    final _height = MediaQuery.of(context).size.height;

    if (!controller.hasTasks) {
      return SizedBox(height: _height * .03);
    } else {
      final _tasks = controller.tasks;

      return Column(
        children: [
          _header('Atividades'),
          Container(
            height: _height * .2,
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final t = _tasks[index];
                return TaskInfoCard(
                  task: t,
                  short: true,
                  onTap: () async => await controller.showDetails(t),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  void _handleScroll() async {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        controller.setExtended(false);
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        controller.setExtended(true);
      }
    });
  }

  Widget _header(String title) {
    final accent = Theme.of(context).accentColor;

    return Container(
      child: Center(
        child: Column(
          children: [
            Divider(height: 5),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    color: accent,
                  ),
                ),
              ),
            ),
            Divider(height: 5),
          ],
        ),
      ),
    );
  }
}

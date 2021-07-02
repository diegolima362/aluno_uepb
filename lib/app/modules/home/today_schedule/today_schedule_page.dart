import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/modules/routes.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'today_schedule_controller.dart';

class TodaySchedulePage extends StatefulWidget {
  @override
  _TodaySchedulePageState createState() => _TodaySchedulePageState();
}

class _TodaySchedulePageState
    extends ModularState<TodaySchedulePage, TodayScheduleController> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => CustomScaffold(
        actions: _buildActions(),
        titleText: Format.dayOfWeek(DateTime.now(), capitalized: true),
        subtitleText: Format.fullDate(DateTime.now()),
        body: _buildBody(),
        floatingActionButton: _buildFAB(),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      if (controller.hasAlerts)
        IconButton(
          icon: Icon(Icons.notifications_on_rounded),
          tooltip: 'Ver alertas',
          onPressed: () => Modular.to.pushNamed(
            NOTIFICATION,
            arguments: controller.alerts,
          ),
        )
    ];
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return LoadingIndicator(text: 'Carregando');
    } else if (controller.hasError) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Error ao obter os dados!',
      );
    } else if (controller.courses.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Você não tem aula hoje!',
      );
    } else {
      return ListView.builder(
        itemCount: controller.courses.length,
        itemBuilder: (context, index) {
          final course = controller.courses[index];
          return CourseInfoCard(
            course: course,
            weekDay: DateTime.now().weekday,
            onTap: () => Modular.to.pushNamed(
              '/rdm/course-details',
              arguments: course,
            ),
          );
        },
      );
    }
  }

  Widget? _buildFAB() {
    if (!controller.hasError)
      return CustomFAB(
        onPressed: () => Modular.to.pushNamed('full-schedule'),
        tooltip: 'Mostrar horário completo',
        label: 'Horário completo',
        extended: true,
        icon: Icon(Icons.calendar_today),
      );
  }
}

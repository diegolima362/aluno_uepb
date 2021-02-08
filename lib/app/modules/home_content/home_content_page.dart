import 'package:aluno_uepb/app/modules/rdm/components/course_info_card.dart';
import 'package:aluno_uepb/app/shared/components/custom_fab.dart';
import 'package:aluno_uepb/app/shared/components/custom_scaffold.dart';
import 'package:aluno_uepb/app/shared/components/empty_content.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_content_controller.dart';

class HomeContentPage extends StatefulWidget {
  final String title;

  const HomeContentPage({Key key, this.title = "HomeContent"})
      : super(key: key);

  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState
    extends ModularState<HomeContentPage, HomeContentController> {
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textTitle: Format.dayOfWeek(DateTime.now(), capitalized: true),
      subtitleText: Format.fullDate(DateTime.now()),
      body: Observer(builder: (_) => _buildContent()),
      floatingActionButton: Observer(builder: (_) => _buildFAB()),
      scrollController: _scrollController,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _handleScroll();
  }

  Widget _buildContent() {
    if (controller.courses == null) {
      return Center(child: CircularProgressIndicator());
    } else if (controller.courses.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Você não tem aula hoje!',
      );
    } else {
      final courses = controller.courses;
      final _length = courses.length;

      return ListView.builder(
        itemCount: _length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseInfoCard(
            course: course,
            weekDay: DateTime.now().weekday,
            onTap: () async => await controller.showDetails(course),
          );
        },
      );
    }
  }

  Widget _buildFAB() {
    final extended = controller.extended;

    return CustomFAB(
      onPressed: controller.showFullSchedule,
      tooltip: 'Mostrar horário completo',
      label: 'Horário completo',
      extended: extended,
      icon: Icon(Icons.calendar_today),
    );
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
}

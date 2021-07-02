import 'package:aluno_uepb/app/modules/home/rdm/details/alerts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../components/course_full_info_card.dart';
import 'rdm_details_controller.dart';
import 'tasks_page.dart';

class RDMDetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState
    extends ModularState<RDMDetailsPage, RDMDetailsController> {
  final pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: _buidBody(),
    );
  }

  Widget _buidBody() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView(
          onPageChanged: controller.setPage,
          scrollDirection: Axis.horizontal,
          controller: pageController,
          children: <Widget>[
            TasksPage(),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 100),
              child: CourseFullInfoCard(
                course: controller.course,
                context: context,
                elevation: 0,
                color: Theme.of(context).canvasColor,
              ),
            ),
            AlertsPage(),
          ],
        ),
        Positioned(
          bottom: 10,
          child: Observer(
            builder: (_) => DotIndicators(currentIndex: controller.currentPage),
          ),
        )
      ],
    );
  }
}

class DotIndicators extends StatelessWidget {
  final int currentIndex;

  const DotIndicators({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final caption = Theme.of(context).textTheme.caption!.color;
    final accent = Theme.of(context).accentColor;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 5,
              width: 5,
              color: i == currentIndex ? accent : caption,
            ),
          ),
        ).toList(),
      ),
    );
  }
}

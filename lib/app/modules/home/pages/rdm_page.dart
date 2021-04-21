import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RdmPage extends StatefulWidget {
  final String title;

  const RdmPage({Key? key, this.title = "RDM"}) : super(key: key);

  @override
  _RdmPageState createState() => _RdmPageState();
}

class _RdmPageState extends ModularState<RdmPage, RdmController> {
  //use 'controller' variable to access controller

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: Observer(builder: (_) => _buildFAB()),
      body: _buildContent(),
      textTitle: widget.title,
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
    _handleScroll();
  }

  Widget _buildContent() {
    // final aspect = portrait ? width / (height * .6) : height / (width * .5);

    return Observer(
      builder: (_) {
        if (controller.isLoading) {
          return LoadingIndicator(text: 'Carregando');
        } else if (controller.courses.isEmpty) {
          return Center(
            child: EmptyContent(
              title: 'Nada por aqui',
              message: 'Você não possui cursos registrados',
            ),
          );
        } else {
          // final h = MediaQuery.of(context).size.height;
          final w = MediaQuery.of(context).size.width;

          final portrait =
              MediaQuery.of(context).orientation == Orientation.portrait;

          final _length = controller.courses.length + 1;
          final padding = w * (portrait ? 0 : 0.15);

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _length,
            itemBuilder: (context, index) {
              if (index == _length - 1) return SizedBox(height: 75.0);
              final course = controller.courses[index];
              final _key = GlobalKey();
              return RepaintBoundary(
                key: _key,
                child: Container(
                  padding: EdgeInsets.only(left: padding, right: padding),
                  width: w * (portrait ? 1 : .6),
                  height: 400,
                  child: CourseFullInfoCard(
                    // height: 300,
                    course: course,
                    context: context,
                    onTap: () => controller.showDetails(course),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildFAB() {
    final extended = controller.extended;

    return CustomFAB(
      color: Theme.of(context).canvasColor,
      onPressed: controller.update,
      tooltip: 'Atualizar dados',
      label: 'Atualizar',
      extended: extended,
      icon: Icon(Icons.update_sharp),
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

import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../rdm_controller.dart';
import 'course_full_info_card.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({
    Key? key,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  final RdmController controller;
  final void Function(CourseModel)? onTap;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (controller.isLoading) {
          return LoadingIndicator(text: 'Carregando');
        } else if (controller.hasError) {
          return Center(
            child: EmptyContent(
              title: 'Nada por aqui',
              message: 'Erro ao obter os dados!',
            ),
          );
        } else if (controller.courses.isEmpty) {
          return Center(
            child: EmptyContent(
              title: 'Nada por aqui',
              message: 'Você não possui cursos registrados',
            ),
          );
        }

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

            return Container(
              padding: EdgeInsets.only(left: padding, right: padding),
              width: w * (portrait ? 1 : .6),
              height: 400,
              child: CourseFullInfoCard(
                course: course,
                context: context,
                onTap: () {
                  if (onTap != null) onTap!(course);
                },
              ),
            );
          },
        );
      },
    );
  }
}

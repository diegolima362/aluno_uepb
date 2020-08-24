import 'package:cau3pb/themes/custom_themes.dart';
import 'package:cau3pb/widgets/empty_content.dart';
import 'package:flutter/material.dart';

class AllTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Atividades',
          style: TextStyle(color: CustomThemes.accentColor),
        ),
      ),
      body: EmptyContent(
        title: 'Nada por aqui',
        message: 'Você ainda não adicionou uma atividade',
      ),
    );
  }
}

import 'dart:io';

import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:aluno_uepb/app/utils/connection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as pp;

import 'components/courses_list.dart';
import 'rdm_controller.dart';
import '../routes.dart';

class RdmPage extends StatefulWidget {
  final String title;

  const RdmPage({Key? key, this.title = "RDM"}) : super(key: key);

  @override
  _RdmPageState createState() => _RdmPageState();
}

class _RdmPageState extends ModularState<RdmPage, RdmController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      actions: _buildActions(context),
      floatingActionButton: _buildFAB(),
      body: CoursesList(
        controller: controller,
        onTap: (c) => Modular.to.pushNamed(COURSE_DETAILS, arguments: c),
      ),
      titleText: widget.title,
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      Observer(
        builder: (_) => Visibility(
          visible: !controller.isLoading && !controller.hasError,
          child: IconButton(
            tooltip: 'Imprimir RDM',
            onPressed: () async => await _download(),
            icon: Icon(
              Icons.print,
              color: Theme.of(context).textTheme.caption?.color,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildFAB() => Observer(
        builder: (_) => Visibility(
          visible: !controller.isLoading,
          child: CustomFAB(
            color: Theme.of(context).canvasColor,
            onPressed: () async {
              if (!(await _checkConnection())) return;
              controller.update();
            },
            tooltip: 'Atualizar dados',
            label: 'Atualizar',
            extended: true,
            icon: Icon(Icons.update_sharp),
          ),
        ),
      );

  Future<void> _download() async {
    if (!(await _checkConnection())) return;

    try {
      controller.setLoading(true);
      final data = await Modular.get<DataController>().downloadRDM();

      if (data != null) {
        final path = (await pp.getExternalStorageDirectory())?.path;

        if (path != null) {
          try {
            final file = File('$path/rdm.html');

            await file.writeAsBytes(data);
            await OpenFile.open(file.path);
          } catch (e) {
            print('RDMPage > \n$e');
          }
        }
      }
      controller.setLoading(false);
    } catch (e) {
      controller.setLoading(false);
      print(e);
      PlatformAlertDialog(
        title: 'Erro',
        content: Text('Erro ao se conectar ao Controle Acadêmico'),
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  Future<bool> _checkConnection() async {
    try {
      return await CheckConnection.checkConnection();
    } catch (_) {
      PlatformAlertDialog(
        title: 'Erro',
        content: Text('Problema de conexão!'),
        defaultActionText: 'OK',
      ).show(context);
      return false;
    }
  }
}

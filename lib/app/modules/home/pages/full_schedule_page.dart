import 'dart:io';

import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:asuka/asuka.dart' as asuka;

class FullSchedulePage extends StatefulWidget {
  final String title;

  const FullSchedulePage({Key? key, this.title = "Horário Completo"})
      : super(key: key);

  @override
  _FullSchedulePageState createState() => _FullSchedulePageState();
}

class _FullSchedulePageState
    extends ModularState<FullSchedulePage, FullScheduleController> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      body: Observer(builder: (_) => _buildContent()),
      floatingActionButton: Observer(builder: (_) => _buildFAB()),
    );
  }

  Widget _buildContent() {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      final height = MediaQuery.of(context).size.height;

      final list = <Widget>[];

      for (int i = 1; i < 6; i++) {
        list.add(
          WeekDayScheduleCard(
            courses: controller.classesAtDay(i),
            showCurrentClass: false,
            weekDay: i,
          ),
        );
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Screenshot(
          controller: _screenshotController,
          child: Container(
            color: Theme.of(context).canvasColor,
            height: height * .85,
            child: Row(children: list),
          ),
        ),
      );
    }
  }

  Widget _buildFAB() {
    final extended = controller.extended;

    return CustomFAB(
      onPressed: () async => await _saveScreen(),
      tooltip: 'Salvar como imagem',
      label: 'Salvar imagem',
      extended: extended,
      icon: Icon(Icons.save_outlined),
    );
  }

  Future<bool> _requestPermission() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.storage,
    ].request();

    final info = status[Permission.storage]?.isGranted ?? false;
    return info;
  }

  Future<void> _saveScreen() async {
    if (await _requestPermission()) {
      final image = await _screenshotController.capture(pixelRatio: 2);

      if (image != null) {
        final path = (await pp.getApplicationDocumentsDirectory()).path;
        final file = File('$path/${DateTime.now().microsecondsSinceEpoch}.jpg');
        file.writeAsBytes(image);

        final result =
            await GallerySaver.saveImage(file.path, albumName: 'RDM');

        if (result ?? false) {
          asuka.showDialog(builder: (_) {
            final navigator = Navigator.of(_);
            return AlertDialog(
              title: Text('Sucesso'),
              content: Text('Imagem Salva'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => navigator.pop(true),
                ),
              ],
            );
          });
        }
      }
    }
  }
}

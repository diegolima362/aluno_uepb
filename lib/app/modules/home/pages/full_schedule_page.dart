import 'dart:io';
import 'dart:typed_data';

import 'package:aluno_uepb/app/modules/home_content/full_schedule/components/week_day_schedule_card.dart';
import 'package:aluno_uepb/app/shared/components/custom_fab.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/full_schedule_controller.dart';

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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: WeekDayScheduleCard(
                courses: controller.classesAtDay(i),
                showCurrentClass: false,
                weekDay: i,
              ),
            ),
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
    _showSnackBar(info ? 'Acesso permitido' : 'Acesso Negado');
    return info;
  }

  Future<void> _saveScreen() async {
    if (await _requestPermission()) {
      final Uint8List? data =
          await _screenshotController.capture(pixelRatio: 2);

      if (data != null) {
        if (Platform.isIOS || Platform.isAndroid) {
          bool status = await Permission.storage.isGranted;
          print(status);
          if (!status) await Permission.storage.request();
        }
        MimeType type = MimeType.JPEG;
        final val = await FileSaver.instance.saveFile(
          Format.simpleDate(DateTime.now()),
          data,
          "jpg",
          mimeType: type,
        );
        print(val);

        _showSnackBar('Imagem salva na galeria');
        Modular.get<IEventLogger>().logEvent('logSaveImageFullSchedule');
      }
    }
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Theme.of(context).backgroundColor),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as pp;

import 'full_schedule_controller.dart';

class FullSchedulePage extends StatefulWidget {
  final String title;

  const FullSchedulePage({Key? key, this.title = "Horário Completo"})
      : super(key: key);

  @override
  _FullSchedulePageState createState() => _FullSchedulePageState();
}

class _FullSchedulePageState
    extends ModularState<FullSchedulePage, FullScheduleController> {
  final _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        if (controller.isLoading) {
          return LoadingIndicator(text: 'Carregando');
        }

        final height = MediaQuery.of(context).size.height * .85;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: RepaintBoundary(
            key: _globalKey,
            child: Container(
              color: Theme.of(context).canvasColor,
              height: height,
              child: _buildCards(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCards() {
    final days = List<int>.generate(5, (i) => i + 1);

    return Row(
      children: days
          .map(
            (i) => WeekDayScheduleCard(
              courses: controller.classesAtDay(i),
              showCurrentClass: false,
              weekDay: i,
            ),
          )
          .toList(),
    );
  }

  Widget _buildFAB() {
    return CustomFAB(
      onPressed: () async => await _saveScreen(),
      tooltip: 'Compartilhar',
      label: 'Compartilhar',
      extended: true,
      icon: Icon(Icons.ios_share_outlined),
    );
  }

  Future<void> _saveScreen() async {
    final image = await _capturePng();

    if (image != null) {
      try {
        final path = (await pp.getExternalStorageDirectory())?.path;

        if (path != null) {
          final file = File('$path/rdm.jpg');

          await file.writeAsBytes(image);
          await OpenFile.open(file.path);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<Uint8List?> _capturePng() async {
    try {
      controller.setIsLoading(true);
      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      controller.setIsLoading(false);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      controller.setIsLoading(false);
      print('FullSchedulePage > \n$e');
      return null;
    }
  }
}

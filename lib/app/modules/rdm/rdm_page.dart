import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:aluno_uepb/app/shared/components/custom_fab.dart';
import 'package:aluno_uepb/app/shared/components/custom_scaffold.dart';
import 'package:aluno_uepb/app/shared/components/empty_content.dart';
import 'package:aluno_uepb/app/shared/event_logger/interfaces/event_logger_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/course_full_info_card.dart';
import 'rdm_controller.dart';

class RdmPage extends StatefulWidget {
  final String title;

  const RdmPage({Key key, this.title = "RDM"}) : super(key: key);

  @override
  _RdmPageState createState() => _RdmPageState();
}

class _RdmPageState extends ModularState<RdmPage, RdmController> {
  //use 'controller' variable to access controller

  ScrollController _scrollController;

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
    _scrollController = ScrollController();
    _handleScroll();
  }

  Widget _buildContent() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final aspect = portrait ? width / (height * .6) : height / (width * .5);

    return Observer(
      builder: (_) {
        if (controller.courses == null) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.courses?.isEmpty ?? true) {
          return Center(
            child: EmptyContent(
              title: 'Nada por aqui',
              message: 'Você não possui cursos registrados',
            ),
          );
        } else {
          final _length = controller.courses.length;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: portrait ? 1 : 2,
              childAspectRatio: aspect,
            ),
            itemCount: _length,
            itemBuilder: (context, index) {
              final course = controller.courses[index];
              final _key = GlobalKey();
              return RepaintBoundary(
                key: _key,
                child: CourseFullInfoCard(
                  course: course,
                  onLongPress: () async => await _saveScreen(_key),
                  context: context,
                  onTap: () async => await controller.showDetails(course),
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

  Future<void> _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].isGranted
        ? 'Acesso permitido'
        : 'Acesso Negado';

    _showSnackBar(info);
  }

  Future<void> _saveScreen(GlobalKey key) async {
    try {
      print('save image');
      await _requestPermission();
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();

      await ImageGallerySaver.saveImage(
        pngBytes,
        name: (DateTime.now().millisecondsSinceEpoch ~/ 6000).toString(),
        quality: 100,
      );

      _showSnackBar('Imagem salva na galeria');
      Modular.get<IEventLogger>().logEvent('logShareCourseInfo');
    } catch (e) {
      print(e);
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

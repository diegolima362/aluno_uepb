import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HistoryPage extends StatefulWidget {
  final String title;

  const HistoryPage({Key? key, this.title = "HomeContent"}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends ModularState<HistoryPage, HistoryController> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      textTitle: 'Histórico',
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
    _handleScroll();
  }

  Widget _buildContent() {
    print('loading: ${controller.isLoading}');
    if (controller.isLoading) {
      return LoadingIndicator(text: 'Carregando');
    } else if (controller.history.isEmpty) {
      return EmptyContent(
        title: 'Nada por aqui',
        message: 'Você não tem histórico registrado!',
      );
    } else {
      final historyList = controller.history;
      final _length = historyList.length;

      return ListView.builder(
        itemCount: _length + 1,
        itemBuilder: (context, index) {
          if (index == _length) return Container(height: 75);
          final history = historyList[index];
          return HistoryEntryCard(history: history);
        },
      );
    }
  }

  Widget _buildFAB() {
    final extended = controller.extended;

    return CustomFAB(
      onPressed: controller.update,
      tooltip: 'Atualizar histórico',
      label: 'Atualizar histórico',
      extended: extended,
      icon: Icon(Icons.update),
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

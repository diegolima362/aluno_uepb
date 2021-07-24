import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/utils/connection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'history_controller.dart';

class HistoryPage extends StatefulWidget {
  final String title;

  const HistoryPage({Key? key, this.title = "HomeContent"}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends ModularState<HistoryPage, HistoryController> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'Histórico',
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBody() {
    return Observer(
      builder: (context) {
        if (controller.isLoading) {
          return LoadingIndicator(text: 'Carregando');
        } else if (controller.hasError) {
          return EmptyContent(
            title: 'Nada por aqui',
            message: 'Erro ao obter os dados!',
          );
        } else if (controller.history.isEmpty) {
          return EmptyContent(
            title: 'Nada por aqui',
            message: 'Você não tem histórico registrado!',
          );
        }

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
      },
    );
  }

  Widget _buildFAB() {
    return Observer(builder: (_) {
      return Visibility(
        visible: !controller.isLoading,
        child: CustomFAB(
          tooltip: 'Atualizar histórico',
          label: 'Atualizar',
          extended: true,
          icon: Icon(Icons.update),
          onPressed: () async {
            if (!(await _checkConnection(context))) return;
            controller.update();
          },
        ),
      );
    });
  }

  Future<bool> _checkConnection(BuildContext context) async {
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

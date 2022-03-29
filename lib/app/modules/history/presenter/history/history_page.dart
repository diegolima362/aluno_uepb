import 'package:aluno_uepb/app/modules/history/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/errors/errors.dart';
import '../widgets/widgets.dart';
import 'history_store.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key) {
    Modular.get<HistoryStore>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HistoryStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      body: ScopedBuilder<HistoryStore, HistoryFailure, List<HistoryEntity>>(
        store: store,
        onError: (_, error) => EmptyCollection.error(message: error?.message),
        onLoading: (context) => const Center(child: Text('Carregando')),
        onState: (context, state) {
          if (state.isEmpty) {
            return const EmptyCollection(
              text: 'Histórico vazio',
              icon: Icons.hourglass_disabled_outlined,
            );
          } else {
            return HistoryCardList(history: state, onRefresh: store.updateData);
          }
        },
      ),
    );
  }
}

import 'package:asp/asp.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../shared/domain/extensions/extensions.dart';
import '../../../../shared/ui/widgets/empty_collection.dart';
import '../atoms/history_atom.dart';
import '../components/history_tile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistory();
      historyResultState
        ..removeListener(resultListener)
        ..addListener(resultListener);
    });
  }

  void resultListener() {
    final result = historyResultState.value;
    if (result == null) return;

    void resetResult() {
      historyResultState.value = null;
    }

    result.fold(
      (success) => context.showMessage(success, resetResult),
      (failure) => context.showError(failure.message, resetResult),
    );
  }

  void resetResult() {
    historyResultState.value = null;
  }

  @override
  void dispose() {
    historyResultState.removeListener(resultListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (isLoading, history, _) = context.select(
      () => (
        historyLoadingState.value,
        historyState.value,
        historyState.value.length,
      ),
    );

    late Widget body;

    if (isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (history.isEmpty) {
      body = const EmptyCollection(
        text: 'Histórico vazio',
        icon: Icons.history,
      );
    } else {
      final groups = history.groupListsBy((e) => e.semester);

      final widgets = <Widget>[];
      for (final e in groups.entries) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              e.key,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
          ),
        );
        for (final h in e.value) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: HistoryTile(history: h),
            ),
          );
        }
      }
      body = ListView.builder(
        itemCount: widgets.length,
        padding: const EdgeInsets.all(24),
        itemBuilder: (_, index) => widgets[index],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            onPressed: refreshHistory,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: reverseHistory,
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: body,
    );
  }
}

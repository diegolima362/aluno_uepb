import 'package:asp/asp.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../core/extensions/extensions.dart';
import '../../interactor/actions/actions.dart';
import '../../interactor/atoms/history_atoms.dart';
import '../components/components.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with HookStateMixin {
  final _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useAtomState(historyLoadingState);
    final history = useAtomState(historyState);

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
      // body = ListView.builder(
      //   itemCount: widgets.length,
      //   padding: const EdgeInsets.all(24),
      //   itemBuilder: (_, index) => widgets[index],
      // );
      final first = history.first;
      int columnCount = first.props.length;
      if (first.type.isEmpty) {
        columnCount--;
      }
      if (first.credits.isEmpty) {
        columnCount--;
      }

      body = RefreshIndicator(
        onRefresh: () async {
          refreshHistory();
        },
        child: TableView.builder(
          verticalDetails: ScrollableDetails.vertical(
            controller: _verticalController,
          ),
          pinnedRowCount: 1,
          cellBuilder: _buildCell,
          columnCount: columnCount,
          columnBuilder: _buildColumnSpan,
          rowCount: history.length + 1,
          rowBuilder: _buildRowSpan,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),
      body: body,
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    if (vicinity.row == 0) {
      final labels = [
        'Semestre',
        'Código',
        'Nome',
        'Horas',
        'Nota',
        'Status',
        'Tipo',
        'Créditos',
      ];
      return TableViewCell(
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (vicinity.column == 0) {
              } else if (vicinity.column == 2) {}
            },
            child: Text(
              labels[vicinity.column],
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final entry = historyState.state[vicinity.row];
    final value = entry.props.elementAt(vicinity.column);
    return TableViewCell(
      child: Center(
        child: Tooltip(
          message: vicinity.column == 2 ? value : '',
          textAlign: TextAlign.center,
          child: Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    const TableSpanDecoration decoration = TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(),
      ),
    );

    final width = index == 2 ? 200.0 : 120.0;

    return TableSpan(
      foregroundDecoration: decoration,
      extent: FixedTableSpanExtent(width),
      onEnter: (_) => print('Entered column $index'),
    );
  }

  TableSpan _buildRowSpan(int index) {
    final color = index == 0
        ? context.colors.surfaceContainer
        : index.isEven
            ? context.colors.surfaceContainerHighest
            : context.colors.surface;
    final decoration = TableSpanDecoration(
      color: color,
    );

    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FixedTableSpanExtent(75),
      recognizerFactories: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer t) => t.onTap = () => print('Tap row $index'),
        ),
      },
    );
  }
}

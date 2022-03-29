import 'package:aluno_uepb/app/core/domain/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../domain/entities/history_entity.dart';

class HistoryCardList extends HookWidget {
  final List<HistoryEntity> history;
  final ScrollController? controller;
  final Future<void> Function() onRefresh;

  const HistoryCardList(
      {Key? key,
      required this.history,
      this.controller,
      required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseSort = useState<int?>(null);
    final courseAsc = useState(false);

    final attSort = useState<int?>(null);
    final attAsc = useState(false);

    final state = useState(history);

    final scheme = Theme.of(context).colorScheme;
    final headingRowColor = MaterialStateProperty.resolveWith(
      (_) => scheme.secondaryContainer.withOpacity(0.25),
    );

    final textTheme = Theme.of(context).textTheme;

    final columnTheme = textTheme.titleMedium;
    final rowTheme = textTheme.bodySmall;

    return RefreshIndicator(
      onRefresh: onRefresh,
      semanticsLabel: 'Atualizar histórico',
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: DataTable(
                sortColumnIndex: courseSort.value,
                sortAscending: courseAsc.value,
                headingRowColor: headingRowColor,
                columnSpacing: 32,
                dividerThickness: 0.2,
                dataRowHeight: 64,
                columns: [
                  DataColumn(
                    label: Text('Curso', style: columnTheme),
                    tooltip: 'Curso',
                    onSort: (a, b) {
                      if (b) {
                        state.value.sort(
                          (a, b) => a.name.withoutDiacriticalMarks
                              .compareTo(b.name.withoutDiacriticalMarks),
                        );
                      } else {
                        state.value.sort(
                          (a, b) => b.name.withoutDiacriticalMarks
                              .compareTo(a.name.withoutDiacriticalMarks),
                        );
                      }

                      courseSort.value = a;
                      courseAsc.value = b;
                      attSort.value = null;
                    },
                  ),
                ],
                rows: state.value
                    .map(
                      (e) => DataRow(
                        cells: [DataCell(Text(e.name, style: rowTheme))],
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: headingRowColor,
                  sortAscending: attAsc.value,
                  sortColumnIndex: attSort.value,
                  columnSpacing: 28,
                  dividerThickness: 0.2,
                  dataRowHeight: 64,
                  columns: [
                    DataColumn(
                      label: Text('Semestre', style: columnTheme),
                      tooltip: 'Semestre',
                      onSort: (a, b) {
                        if (b) {
                          state.value.sort(
                            (a, b) => a.semester.compareTo(b.semester),
                          );
                        } else {
                          state.value.sort(
                            (a, b) => b.semester.compareTo(a.semester),
                          );
                        }

                        attSort.value = a;
                        attAsc.value = b;
                        courseSort.value = null;
                      },
                    ),
                    DataColumn(
                      label: Text('C.H.', style: columnTheme),
                    ),
                    DataColumn(
                      label: Text('Faltas', style: columnTheme),
                      tooltip: 'Faltas',
                    ),
                    DataColumn(
                      label: Text('Média', style: columnTheme),
                      tooltip: 'Média',
                      onSort: (a, b) {
                        if (b) {
                          state.value.sort(
                            (a, b) => (double.tryParse(a.grade) ?? -1)
                                .compareTo((double.tryParse(b.grade) ?? -1)),
                          );
                        } else {
                          state.value.sort(
                            (a, b) => (double.tryParse(b.grade) ?? -1)
                                .compareTo((double.tryParse(a.grade) ?? -1)),
                          );
                        }

                        attSort.value = a;
                        attAsc.value = b;
                        courseSort.value = null;
                      },
                    ),
                    DataColumn(
                      label: Text('Status', style: columnTheme),
                      tooltip: 'Status',
                    ),
                  ],
                  rows: state.value
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(Text(e.semester, style: rowTheme)),
                            DataCell(Text(e.cumulativeHours, style: rowTheme)),
                            DataCell(Text(e.absences, style: rowTheme)),
                            DataCell(Text(e.grade, style: rowTheme)),
                            DataCell(Text(e.status, style: rowTheme)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

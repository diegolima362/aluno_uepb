import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../../infra/models/models.dart';

String trim(Element e) => e.text.trim();

List<HistoryModel> extractHistory(Document doc) {
  final history = <HistoryModel>[];

  final panel =
      doc.getElementsByClassName('text-primary').map((e) => e.text.trim());

  if (panel.isEmpty || !panel.contains('Histórico Escolar')) {
    throw ParseError('Erro ao formatar os dados do histórico!', null, null);
  }

  final rows = doc.getElementsByTagName('tr').skip(1);

  for (final row in rows) {
    final items = row.getElementsByTagName('td').map(trim).toList();

    history.add(HistoryModel(
      id: items[0],
      name: items[1],
      semester: items[2],
      cumulativeHours: items[4],
      grade: items[5].isNotEmpty ? items[5] : '-',
      absences: items[6].isNotEmpty ? items[6] : '0',
      status: items[7],
    ));
  }

  return history;
}

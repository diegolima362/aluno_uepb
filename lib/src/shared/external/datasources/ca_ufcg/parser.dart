import 'package:html/dom.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/types/types.dart';

final regexpInts = RegExp(r'\d+');
final findAbsences = RegExp(r'gauge\d+.set\((\d+)');

String trim(Element e) => e.text.trim();

List<Course> parseCourses(Document document) {
  final courses = <Course>[];

  final table = document.querySelector('.table-responsive');

  if (table == null) {
    return [];
  }

  final rows = table.getElementsByTagName('tr').skip(1);

  for (final r in rows) {
    final tds = r.getElementsByTagName('td');

    final codeAndTitle = tds[1].text.split('-');
    final code = codeAndTitle[0].trim();
    final title = codeAndTitle[1].trim();

    final strSchedule = tds[4].text.trim().split('\n');
    final schedule = strSchedule.map(_parseSchedule).toList();

    courses.add(
      Course(
        classId: tds[0].text.trim(),
        title: title,
        courseCode: code,
        credits: int.tryParse(tds[2].text.trim()) ?? 0,
        totalHours: int.tryParse(tds[3].text.trim()) ?? 0,
        schedule: schedule,
        professors: [],
        absences: 0,
        absenceLimit: 0,
      ),
    );
  }

  courses.sort((a, b) => a.title.compareTo(b.title));

  return courses;
}

Schedule _parseSchedule(String text) {
  final parts = text.split(' ');
  return Schedule(
    weekday: (int.tryParse(parts[0]) ?? 1) - 1,
    startTime: parts[1].split('-').first.trim(),
    endTime: parts[1].split('-').last.trim(),
    local: parts[2].substring(1, parts[2].length - 1),
  );
}

Profile parseProfile(Document document) {
  final panels = document.querySelectorAll('.panel-body');
  if (panels.isEmpty) {
    throw AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    );
  }
  final items = panels[0].querySelectorAll('.col-sm-6');
  if (items.isEmpty) {
    throw AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    );
  }

  var info = items[0].text.split(':').last.trim();
  final register = info.split(' ').first;
  final name = info.split(' ').skip(1).join(' ');

  final program = items[4].text.split(':').last.trim().split('(').first.trim();

  final progress = document.querySelectorAll('#integralizacao tr').last;
  final progressTds = progress.getElementsByTagName('td');

  final totalHours = progressTds[1].text.split('(').first.trim();
  final credits = progressTds[3].text.split('(').first.trim();

  final indexesRow = panels[1].querySelector('.row');

  if (indexesRow == null) {
    throw AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    );
  }

  final indexes = <AcademicIndex>[];

  final indexesCols = indexesRow.querySelectorAll('.col-md-2');
  for (int i = 0; i < indexesCols.length; i += 2) {
    final label = indexesCols[i].text.split(':').first.trim();
    final value = indexesCols[i + 1].text.trim();
    indexes.add(AcademicIndex(label: label, value: value));
  }

  return Profile(
    name: name,
    register: register,
    program: program,
    totalHours: totalHours,
    credits: credits,
    academicIndexes: indexes,
    campus: '',
  );
}

List<History> parseHistory(Document document) {
  final items = document.querySelectorAll('#disciplinas tbody tr');
  if (items.isEmpty) {
    throw AppException('Erro ao consultar histórico.');
  }

  final history = <History>[];

  for (final item in items) {
    final tds = item.getElementsByTagName('td');
    final professors =
        tds[1].querySelectorAll('.small').map((e) => e.text.trim()).toList();

    history.add(
      History(
        code: tds[0].text.trim(),
        name: tds[1].firstChild?.text?.trim() ?? '',
        professors: professors,
        type: tds[2].text.trim(),
        credits: tds[3].text.trim(),
        totalHours: tds[4].text.trim(),
        grade: tds[5].text.trim(),
        status: tds[6].text.trim(),
        semester: tds[7].text.trim(),
      ),
    );
  }

  return history;
}

Result<(int total, int limit), AppException> parseAbsences(Document document) {
  final th = document.querySelectorAll('thead tr th');
  final td = document.querySelectorAll('tbody tr td');
  if (th.isEmpty || td.isEmpty) {
    return Result.failure(AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    ));
  }

  final limitStr = th[th.length - 2].attributes['title'] ?? '';
  final limit = int.tryParse(limitStr.split(': ').last) ?? 0;

  final total = int.tryParse(td[td.length - 2].text.trim()) ?? 0;

  return Result.success((total, limit));
}

Result<List<Grade>, AppException> parseGrades(Document document) {
  final tds = document.querySelectorAll('tbody tr td');
  final ths = document.querySelectorAll('thead tr th');

  if (tds.isEmpty || ths.isEmpty) {
    return Result.failure(AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    ));
  }

  final labels = ths.sublist(3, 9).map((e) => e.text.trim().split('\n').first);

  final wheigths = ths.sublist(3, 6).map((e) => e.text.trim().split('\n').last);

  final values = tds.sublist(3, 9).map((e) => e.text.trim());

  return Result.success(
    List.generate(
      labels.length,
      (index) => Grade(
        label: labels.elementAt(index),
        value: values.elementAt(index),
        weight: index >= wheigths.length ? '' : wheigths.elementAt(index),
      ),
    ),
  );
}

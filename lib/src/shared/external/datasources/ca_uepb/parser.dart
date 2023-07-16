import 'package:html/dom.dart';

import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/types/types.dart';
import 'constants.dart' as constants;

final regexpInts = RegExp(r'\d+');
final findAbsences = RegExp(r'gauge\d+.set\((\d+)');
final findAbsencesLimit = RegExp(r'gauge\d+.maxValue = \d+');

String trim(Element e) => e.text.trim();

List<Course> parseCourses(Document doc) {
  if (doc.text?.contains(constants.errorAvaliation) ?? false) {
    throw AppException(constants.errorAvaliation);
  }

  final courses = <Course>[];

  final absencesAndLimits = _extractAbsencesAndLimits(doc);
  final absences = absencesAndLimits[0];
  final limits = absencesAndLimits[1];

  final cards = doc.getElementsByClassName('col-md-4');
  for (int i = 0; i < cards.length; i++) {
    final card = cards[i];

    final heading = card
        .getElementsByClassName('user-heading')
        .first
        .children
        .map((e) => e.text)
        .toList();

    final li = card.getElementsByTagName('li');

    if (li.length < 5) {
      li.insert(1, Element.html('<li>Sem Professor</li>'));
    }

    final items = li.map(trim).toList();

    final durationValue = regexpInts.firstMatch(items[0]);
    final totalHours = int.tryParse(durationValue?[0] ?? '0') ?? 0;

    final schedule = _extractSchedule(li[2]);

    final gradesStr = card
        .querySelectorAll('.text-center.col-md-6.col-xs-6')
        .map(trim)
        .toList();

    final grades = gradesStr
        .map((e) => Grade(
              value: e.split('\n').first.trim(),
              label: e.split('\n').last.trim(),
            ))
        .toList();

    courses.add(
      Course(
        courseCode: heading[1],
        title: heading[0],
        professors: [items[1]],
        totalHours: totalHours,
        absences: absences[i],
        absenceLimit: limits[i],
        grades: grades,
        schedule: schedule,
        classId: '',
        credits: 0,
      ),
    );
  }

  courses.sort((a, b) => a.title.compareTo(b.title));

  return courses;
}

List<List<int>> _extractAbsencesAndLimits(Document doc) {
  final text = doc.body!.text;

  final resultAbsences = findAbsences.allMatches(text).toList();
  final resultLimits = findAbsencesLimit.allMatches(text).toList();

  final absences = <int>[];
  final limits = <int>[];

  for (int i = 0; i < resultLimits.length; i++) {
    absences
        .add(int.tryParse(resultAbsences[i][0]?.split('(').last ?? '0') ?? 0);
    limits.add(int.tryParse(resultLimits[i][0]?.split('= ').last ?? '0') ?? 0);
  }

  return [absences, limits];
}

List<Schedule> _extractSchedule(Element element) {
  if (element.text.contains('Sem horário')) {
    return [];
  }

  final s = element.innerHtml.split('\n')[1].trim().split('<br>')..removeLast();

  return s.map(
    (e) {
      final items = e.split(' ');
      return Schedule(
        weekday: _dayToWeekDay(items[0]),
        startTime: items[1],
        local: e.split('Sala:').last.trim(),
      );
    },
  ).toList();
}

int _dayToWeekDay(String day) {
  switch (day) {
    case 'Segunda':
      return 1;
    case 'Terça':
      return 2;
    case 'Quarta':
      return 3;
    case 'Quinta':
      return 4;
    case 'Sexta':
      return 5;
    case 'Sábado':
      return 6;
    default:
      return 0;
  }
}

Profile parseProfile(Document document) {
  if (document.text?.contains(constants.errorAvaliation) ?? false) {
    throw AppException(constants.errorAvaliation);
  }

  final name = document.querySelector('.profile-desk')?.text.trim();

  final cra = document.querySelector('.text-purple')?.text.trim();
  final totalHours = document.querySelector('.ch')?.text.trim();

  final items = document.querySelectorAll('.col-md-6.text-left .text-muted');

  if (items.isEmpty) {
    throw AppException(
      'Erro com os dados recebidos do controle acadêmico!',
    );
  }

  final register = items[0].text.trim();
  final programInfo = items[1].text;

  final program = programInfo.split('-').last.split('(').first.trim();

  final campus = (RegExp(r'\([^)]*\)').firstMatch(programInfo)?[0] ?? '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  return Profile(
    register: register,
    name: name ?? '',
    program: program,
    campus: campus,
    totalHours: totalHours ?? '',
    credits: '',
    academicIndexes: [
      AcademicIndex(
        label: 'CRA',
        value: cra ?? '',
      ),
    ],
  );
}

List<History> parseHistory(Document doc) {
  final history = <History>[];

  final panel =
      doc.getElementsByClassName('text-primary').map((e) => e.text.trim());

  if (panel.isEmpty || !panel.contains('Histórico Escolar')) {
    throw AppException('Erro ao formatar os dados do histórico!');
  }

  final rows = doc.getElementsByTagName('tr').skip(1);

  for (final row in rows) {
    final items = row.getElementsByTagName('td').map(trim).toList();

    history.add(History(
      code: items[0],
      name: items[1],
      semester: items[2],
      totalHours: items[4],
      grade: items[5].isNotEmpty ? items[5] : '-',
      status: items[7],
      professors: [],
      type: '',
      credits: '',
    ));
  }

  return history;
}

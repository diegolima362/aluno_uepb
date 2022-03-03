import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';

import '../../../infra/models/models.dart';

final regexpInts = RegExp(r'\d+');
final findAbsences = RegExp(r'gauge\d+.set\((\d+)');
final findAbsencesLimit = RegExp(r'gauge\d+.maxValue = \d+');

String trim(Element e) => e.text.trim();

Option<ProfileModel> extractProfile(Document doc) {
  final name = doc.getElementsByTagName('h2')[0].text;

  final cra = doc.getElementsByClassName('text-purple')[0].text;
  final ch = doc.getElementsByClassName('ch')[0].text;

  final items = doc.getElementsByClassName('text-muted').map(trim).toList();

  final register = items[0];
  final programInfo = items[1];

  final program = programInfo.split('-').last.split('(').first.trim();

  final campus = (RegExp(r'\([^)]*\)').firstMatch(programInfo)?[0] ?? '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  final profile = ProfileModel(
    register: register,
    name: name,
    program: program,
    campus: campus,
    cra: cra,
    cumulativeHours: ch,
  );

  return some(profile);
}

List<CourseModel> extractCourses(Document doc) {
  final courses = <CourseModel>[];

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
    final duration = int.tryParse(durationValue?[0] ?? '0') ?? 0;

    final schedule = _extractSchedule(li[2]);

    final grades = card.getElementsByTagName('h5').map(trim).toList();

    courses.add(
      CourseModel(
        id: heading[1],
        name: heading[0],
        professor: items[1],
        duration: duration,
        absences: absences[i],
        absencesLimit: limits[i],
        und1Grade: grades[0],
        und2Grade: grades[1],
        finalTest: grades[2],
        scheduleModel: schedule,
      ),
    );
  }

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

List<ScheduleModel> _extractSchedule(Element element) {
  if (element.text.contains('Sem horário')) {
    return [];
  }

  final s = element.innerHtml.split('\n')[1].trim().split('<br>');

  s.removeLast();

  return s.map(
    (e) {
      final items = e.split(' ');
      return ScheduleModel(
        day: items[0],
        time: items[1],
        local: e.split('Sala:').last.trim(),
      );
    },
  ).toList();
}

List<HistoryModel> extractHistory(Document doc) {
  final history = <HistoryModel>[];

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

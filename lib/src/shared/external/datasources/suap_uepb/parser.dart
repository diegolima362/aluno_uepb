import 'package:html/dom.dart';

import '../../../../modules/courses/models/models.dart';
import '../../../../modules/profile/models/profile.dart';
import '../../../data/types/types.dart';

const timeSpots = {
  'M': {
    '1': ('07:00', '08:00'),
    '2': ('08:00', '09:00'),
    '3': ('09:00', '10:00'),
    '4': ('10:00', '11:00'),
    '5': ('11:00', '12:00'),
    '6': ('12:00', '13:00'),
  },
  'V': {
    '1': ('13:00', '14:00'),
    '2': ('14:00', '15:00'),
    '3': ('15:00', '16:00'),
    '4': ('16:00', '17:00'),
    '5': ('17:00', '18:00'),
  },
  'N': {
    '1': ('18:00', '19:00'),
    '2': ('19:00', '20:00'),
    '3': ('20:00', '21:00'),
    '4': ('21:00', '22:00'),
  },
};

String trim(Element e) => e.text.trim();

String parseCookie(String? header) {
  if (header != null && header.isNotEmpty) {
    if (!header.contains('__Host-csrftoken') ||
        !header.contains('__Host-suap-control') ||
        !header.contains('__Host-sessionid')) {
      return header;
    }
    final csrfToken = header.split('__Host-csrftoken=')[1].split(';')[0];
    final suapControl = header.split('__Host-suap-control=')[1].split(';')[0];
    final sessionId = header.split('__Host-sessionid=')[1].split(';')[0];

    return '__Host-csrftoken=$csrfToken; __Host-suap-control=$suapControl; __Host-sessionid=$sessionId';
  }
  return '';
}

List<Course> parseCourses(Document document) {
  final courses = <Course>[];

  final rows = document.querySelectorAll('.borda tbody tr');

  for (final row in rows) {
    final items = row.getElementsByTagName('td');

    final codeTitle = items[1].text.split(' - ');

    final totalHoursText = items[2].text.split(' ').first.trim();
    final totalHours = int.tryParse(totalHoursText) ?? 0;
    final absences = int.tryParse(items[4].text) ?? 0;
    final absenceLimit = (totalHours * 0.25).floor();

    final grades = parseGrades(row);

    courses.add(
      Course(
        courseCode: codeTitle.first.trim(),
        title: codeTitle.last.trim(),
        professors: [],
        totalHours: totalHours,
        absences: absences,
        absenceLimit: absenceLimit,
        grades: grades,
        schedule: [],
        classId: '',
        credits: 0,
      ),
    );
  }

  courses.sort((a, b) => a.title.compareTo(b.title));

  return courses;
}

List<Grade> parseGrades(Element row) {
  final items = row.getElementsByTagName('td');

  final grades = <Grade>[];

  for (final i in items) {
    final headers = i.attributes['headers'];
    if (headers != null) {
      var label = '';
      var value = '';

      switch (headers) {
        case 'th_n1n':
          label = 'N1';
          value = i.text.trim();
        case 'th_n2n':
          label = 'N2';
          value = i.text.trim();
        case 'th_md':
          label = 'Média';
          value = i.text.trim();
        case 'th_naf':
          label = 'NAF';
          value = i.text.trim();
        case 'th_mfd':
          label = 'MFD';
          value = i.text.trim();
      }

      if (value.isEmpty || label.isEmpty) {
        continue;
      }

      grades.add(
        Grade(
          label: label,
          value: value,
        ),
      );
    }
  }

  return grades;
}

Map<String, (List<String>, List<Schedule>)> parseScheduleAndProfessor(
  Document document,
) {
  final map = <String, (List<String>, List<Schedule>)>{};

  final tables = document.querySelectorAll('.table-responsive');
  if (tables.isEmpty) {
    return map;
  }

  final rows = tables[3].querySelectorAll('tbody tr');
  for (final row in rows) {
    final items = row.getElementsByTagName('td');
    if (items.isEmpty) {
      continue;
    }

    final courseInfo = items[1].getElementsByTagName('dd');
    final courseCode = courseInfo[0].text.split(' - ').first.trim();

    final professors = courseInfo[1]
        .text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final schedule = _extractSchedule(row);

    map[courseCode] = (professors, schedule);
  }

  return map;
}

List<Schedule> _extractSchedule(Element element) {
  final items = element.getElementsByTagName('td');
  if (items.isEmpty) {
    return [];
  }

  final local = items[2].text.trim();
  final scheduleCodes =
      items[3].text.trim().split('/').map((e) => e.trim()).toList();

  final schedules = <Schedule>[];

  for (final code in scheduleCodes) {
    // spot = 5M2345
    final charaters = code.split('');
    final weekday = charaters[0];
    final shift = charaters[1];
    final spots = charaters.sublist(2);

    final localSchedule = <Schedule>[];

    for (final spot in spots) {
      localSchedule.add(
        Schedule(
          weekday: (int.tryParse(weekday[0]) ?? 1) - 1,
          startTime: timeSpots[shift]?[spot]?.$1 ?? '',
          endTime: timeSpots[shift]?[spot]?.$2 ?? '',
          local: local,
          localShort: local.split('-').first.trim(),
        ),
      );
    }

    // compressing schedules
    // e.g.: 5M23 => 08:00 - 10:00
    schedules.add(
      Schedule(
        weekday: localSchedule.first.weekday,
        startTime: localSchedule.first.startTime,
        endTime: localSchedule.last.endTime,
        local: local,
        localShort: local.split('-').first.trim(),
      ),
    );
  }

  return schedules;
}

Profile parseProfile(Document document) {
  final items = document
      .querySelectorAll('.list-item.flex-basis-50')
      .map((e) => e.getElementsByTagName('dd').firstOrNull?.text.trim())
      .where((element) => element != null)
      .toList();
  if (items.isEmpty) {
    throw AppException('Erro com os dados recebidos do suap!');
  }

  final name = items[0] ?? '';
  final register = items[1] ?? '';
  final cra = document
      .querySelectorAll('.list-item')
      .map((e) => e.text)
      .firstWhere((e) => e.startsWith('C.R.A'))
      .split('C.R.A.')
      .last
      .trim();

  final hours = document.querySelectorAll('tfoot tr td');
  if (hours.isEmpty) {
    throw AppException('Erro ao formatar os dados do perfil!');
  }
  final totalHours = hours[2].text.trim();

  final programInfo = items[4] ?? '';
  final program = programInfo.split('-').last.split('(').first.trim();
  final campus = (RegExp(r'\([^)]*\)').firstMatch(programInfo)?[0] ?? '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  return Profile(
    register: register,
    name: name,
    program: program,
    campus: campus,
    totalHours: totalHours,
    credits: '',
    academicIndexes: [
      AcademicIndex(
        label: 'CRA',
        value: cra,
      ),
    ],
  );
}

List<History> parseHistory(Document document) {
  final history = <History>[];

  final rows = document.querySelectorAll('tbody tr');

  for (final row in rows) {
    final elements = row.getElementsByTagName('td');
    final items = elements.map(trim).toList();

    String name = '';
    for (final node in elements[4].nodes) {
      if (node.nodeType == Node.TEXT_NODE) {
        name = node.text?.trim() ?? '';
      }
    }

    history.add(History(
      semester: items[0],
      code: items[3],
      name: name,
      totalHours: items[5],
      grade: items[6].isNotEmpty ? items[6] : '-',
      status: items[8],
      credits: '',
      type: '',
      professors: [],
    ));
  }

  return history;
}

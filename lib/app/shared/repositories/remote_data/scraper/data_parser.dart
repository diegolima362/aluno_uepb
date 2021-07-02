import 'package:html/dom.dart';

class DataParser {
  List<Map<String, dynamic>> sanitizeCourses(Document dom) {
    List<Element> data = dom.getElementsByTagName('.profile-nav');
    List<Map<String, dynamic>> courses = <Map<String, dynamic>>[];

    List<int> absences = _sanitizeAbsences(dom);
    List<int> absencesLimit = _sanitizeAbsencesLimit(dom);

    data.forEach((e) {
      courses.add(_buildCourse(e));
    });

    for (int i = 0; i < courses.length; i++) {
      courses[i]['absences'] = absences[i];
      courses[i]['absencesLimit'] = absencesLimit[i];
    }

    return courses;
  }

  List<Map<String, dynamic>> sanitizeHistory(Document dom) {
    List<Element> data = dom.getElementsByTagName('table > tbody > tr');
    List<Map<String, dynamic>> history = <Map<String, dynamic>>[];

    data.forEach((e) => history.add(_buildHistory(e)));

    return history;
  }

  Map<String, dynamic> sanitizeProfile(Map<String, Document?> dom) {
    Map<String, String> homeInfo = _sanitizeHomeInfo(dom['home']!);
    Map<String, dynamic> personalData =
        _sanitizePersonalData(dom['profile']!.body!);

    return _buildProfile(personalData, homeInfo);
  }

  Map<String, dynamic> _buildHistory(Element e) {
    final d = e.getElementsByTagName('td').map((e) => e.text).toList();

    return {
      'id': d[0],
      'name': d[1],
      'semester': d[2],
      'observation': d[3],
      'ch': d[4],
      'grade': d[5],
      'absences': d[6],
      'status': d[7],
    };
  }

  Map<String, dynamic> _buildCourse(Element e) {
    final String name = e.getElementsByTagName('h2')[0].text.trim();
    final String id = e.getElementsByTagName('p')[0].text.trim();

    final List<Element> courseData = e.getElementsByTagName('li');
    final List<Element> gradesData = e.getElementsByTagName('h5');

    final List<String> grades = gradesData.map((e) => e.text).toList();

    if (courseData.length < 5) {
      courseData.insert(1, Element.html('<p>SEM PROFESSOR</p>'));
    }

    int ch = int.tryParse(courseData[0].text.split(' ')[3])!;
    String professor = courseData[1].text;
    List<Map<String, dynamic>> schedule = _sanitizeSchedule(courseData[2]);

    final course = {
      'id': id,
      'name': name,
      'professor': professor,
      'ch': ch,
      'schedule': schedule,
      'und1Grade': grades[0],
      'und2Grade': grades[1],
      'finalTest': grades[2],
    };

    return course;
  }

  Map<String, dynamic> _buildProfile(
    Map<String, dynamic> personalData,
    Map<String, String> homeInfo,
  ) {
    return {
      'name': personalData['name'],
      'register': personalData['register'],
      'cra': homeInfo['cra'],
      'cumulativeCH': homeInfo['cumulativeCH'],
      'building': homeInfo['building'],
      'viewName': personalData['viewName'],
      'birthDateEpoch': personalData['birthDateEpoch'],
      'campus': personalData['campus'],
      'gender': personalData['gender'],
      'program': personalData['program'],
    };
  }

  List<int> _sanitizeAbsences(Document dom) {
    List<int> absences = <int>[];

    RegExp regExp = new RegExp(r"\(\d\.\d\)");
    RegExp regExp2 = new RegExp(r".\.");

    String? scriptTag =
        dom.querySelector('#main-content > section > script')?.text;

    if (scriptTag != null) {
      Iterable<RegExpMatch> values = regExp.allMatches(scriptTag);
      values.forEach((element) {
        absences.add(
            int.tryParse(regExp2.firstMatch(element.group(0)!)!.group(0)![0])!);
      });
    }

    return absences;
  }

  List<int> _sanitizeAbsencesLimit(Document dom) {
    List<int> limits = <int>[];

    RegExp regExp = new RegExp(r"maxValue = (\d*);");
    RegExp regExp2 = new RegExp(r"\d{1,2}");

    String? scriptTag =
        dom.querySelector('#main-content > section > script')?.text;

    if (scriptTag != null) {
      Iterable<RegExpMatch> values = regExp.allMatches(scriptTag);

      values.forEach((e) => limits
          .add(int.tryParse(regExp2.firstMatch(e.group(0)!)!.group(0)!)!));
    }

    return limits;
  }

  Map<String, String> _sanitizeHomeInfo(Document dom) {
    Map<String, String> map = {
      'cra': dom.querySelector('.text-purple')?.text ?? '',
      'cumulativeCH': dom.querySelector('.ch')?.text ?? '',
      'building': dom.querySelector('.nome-predio')?.text ?? '',
    };

    return map;
  }

  Map<String, dynamic> _sanitizePersonalData(Element dom) {
    final data = dom.getElementsByClassName('form-control-static');

    Map<String, dynamic> personalData = Map<String, dynamic>();

    personalData['register'] = data[0].text;
    personalData['name'] = data[1].text;
    personalData['viewName'] = personalData['name'].split(' ')[0];
    personalData['program'] = data[3].text.split(' (')[0].split('- ')[1];
    personalData['campus'] = data[3].text.split('(')[1].split(')')[0];

    List<String> date = data[12].text.split('/');

    DateTime birthDate = DateTime(
      int.tryParse(date[2])!,
      int.tryParse(date[1])!,
      int.tryParse(date[0])!,
    );
    personalData['birthDateEpoch'] = birthDate.microsecondsSinceEpoch.toString();

    personalData['gender'] = data[13].text[0];

    return personalData;
  }

  List<Map<String, dynamic>> _sanitizeSchedule(Element e) {
    final schedule = <Map<String, dynamic>>[];

    RegExp regExp = new RegExp(r"<i(.*?)</i>");
    RegExp regExp2 = new RegExp(r"[\n\t]");

    List<String> str = e.innerHtml
        .replaceAll(regExp, '')
        .replaceAll(regExp2, '')
        .split('<br>');

    str.forEach((element) {
      if (element.length > 1) {
        List<String> t = element.trim().split(' - ');
        List<String> dayTime = t[0].split(' ');

        String day = dayTime[0].toUpperCase();
        String time = dayTime[1];

        String local = t[1].split(': ')[1];

        schedule.add({'day': day, 'time': time, 'local': local});
      }
    });

    return schedule;
  }
}

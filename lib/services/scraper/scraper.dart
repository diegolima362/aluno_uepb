import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';

import 'session.dart';

class Scraper {
  final String user;
  final String password;

  Scraper({@required this.user, @required this.password});

  Future<Map<String, Document>> _requestDOM() async {
    final String baseURL = "https://academico.uepb.edu.br/ca/index.php/alunos";
    final String loginURL =
        "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

    Map<String, String> formData = {
      'nome_usuario': this.user,
      'senha_usuario': this.password
    };

    Session client = Session();

    Document inicio;
    Document cadastro;
    Document rdm;

    // Start cookies
    inicio = await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      cadastro = await client.get(baseURL + '/cadastro');
      inicio = await client.get(baseURL + '/index');
      rdm = await client.get(baseURL + '/rdm');
    } catch (e) {
      rethrow;
    }

    final data = {
      'inicio': inicio,
      'cadastro': cadastro,
      'rdm': rdm,
    };

    return data;
  }

  Future<Map<String, Document>> _requestDOMProfile() async {
    final String baseURL = "https://academico.uepb.edu.br/ca/index.php/alunos";
    final String loginURL =
        "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

    Map<String, String> formData = {
      'nome_usuario': this.user,
      'senha_usuario': this.password
    };

    Session client = Session();

    Document inicio;
    Document cadastro;

    // Start cookies
    inicio = await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      cadastro = await client.get(baseURL + '/cadastro');
      inicio = await client.get(baseURL + '/index');
    } catch (e) {
      rethrow;
    }

    final data = {
      'inicio': inicio,
      'cadastro': cadastro,
    };

    return data;
  }

  Future<Map<String, Document>> _requestDOMCourses() async {
    final String baseURL = "https://academico.uepb.edu.br/ca/index.php/alunos";
    final String loginURL =
        "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

    Map<String, String> formData = {
      'nome_usuario': this.user,
      'senha_usuario': this.password
    };

    Session client = Session();

    Document rdm;

    // Start cookies
    rdm = await client.get(baseURL + '/index');

    try {
      await client.post(loginURL, formData);
      rdm = await client.get(baseURL + '/rdm');
    } catch (e) {
      rethrow;
    }

    final data = {
      'rdm': rdm,
    };

    return data;
  }

  // Future<Map<String, Document>> _requestDOMFake() async {
  //   final String baseURL = "https://192.168.0.109:8000";

  //   Session client = Session();

  //   Document inicio;
  //   Document cadastro;
  //   Document rdm;

  //   try {
  //     cadastro = await client.get(baseURL + '/cadastro');
  //     inicio = await client.get(baseURL + '/inicio');
  //     rdm = await client.get(baseURL + '/rdm');
  //   } catch (e) {
  //     rethrow;
  //   }

  //   final data = {
  //     'inicio': inicio,
  //     'cadastro': cadastro,
  //     'rdm': rdm,
  //   };

  //   return data;
  // }

//  Future<Map<String, Map<String, Document>>> _requestDOMFake(
//      {@required String baseURL}) async {
//    Session client = Session();
//
//    final inicio = await client.get(baseURL + '/inicio/');
//    final cadastro = await client.get(baseURL + '/cadastro/');
//    final rdm = await client.get(baseURL + '/rdm/');
//
//    final data = {
//      'profile': {
//        'inicio': inicio,
//        'cadastro': cadastro,
//      },
//      'courses': {
//        'rdm': rdm,
//      },
//    };
//
//    return data;
//  }

  /// Extract absences for all courses at once.
  List<int> _sanitizeAbsences(Document dom) {
    List<int> absences = List<int>();

    RegExp regExp = new RegExp(r"\(\d\.\d\)");
    RegExp regExp2 = new RegExp(r".\.");

    String scriptTag =
        dom.querySelector('#main-content > section > script')?.text;
    Iterable<RegExpMatch> values = regExp.allMatches(scriptTag);

    values.forEach((element) {
      absences
          .add(int.tryParse(regExp2.firstMatch(element.group(0)).group(0)[0]));
    });

    return absences;
  }

  List<int> _sanitizeAbsencesLimit(Document dom) {
    List<int> limits = List<int>();

    RegExp regExp = new RegExp(r"maxValue = (\d*);");
    RegExp regExp2 = new RegExp(r"\d{1,2}");

    String scriptTag =
        dom.querySelector('#main-content > section > script')?.text;

    Iterable<RegExpMatch> values = regExp.allMatches(scriptTag);

    values.forEach((e) =>
        limits.add(int.tryParse(regExp2.firstMatch(e.group(0)).group(0))));

    return limits;
  }

  List<Map<String, dynamic>> _sanitizeSchedule(Element e) {
    final schedule = List<Map<String, dynamic>>();

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

  Map<String, dynamic> _buildCourse(Element e) {
    final String title = e.getElementsByTagName('h2')[0].text.trim();
    final String id = e.getElementsByTagName('p')[0].text.trim();

    final List<Element> courseData = e.getElementsByTagName('li');
    final List<Element> gradesData = e.getElementsByTagName('h5');

    final List<String> grades = gradesData.map((e) => e.text).toList();

    if (courseData.length < 5) {
      courseData.insert(1, Element.html('<p>SEM PROFESSOR</p>'));
    }

    int ch = int.tryParse(courseData[0].text.split(' ')[3]);
    String professor = courseData[1].text;
    List<Map<String, dynamic>> schedule = _sanitizeSchedule(courseData[2]);

    final course = {
      'id': id,
      'title': title,
      'professor': professor,
      'ch': ch,
      'schedule': schedule,
      'und1Grade': grades[0],
      'und2Grade': grades[1],
      'finalTest': grades[2],
    };

    return course;
  }

  List<Map<String, dynamic>> _sanitizeCourses(Document dom) {
//    print(dom.outerHtml);

    List<Element> data = dom.getElementsByTagName('.profile-nav');
    List<Map<String, dynamic>> courses = List<Map<String, dynamic>>();

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

  Map<String, String> _sanitizeHomeInfo(Document dom) {
    final map = {
      'cra': dom.querySelector('.text-purple')?.text,
      'cumulativeCH': dom.querySelector('.ch')?.text,
      'building': dom.querySelector('.nome-predio')?.text,
    };

    return map;
  }

  Map<String, dynamic> _sanitizePersonalData(Element dom) {
    final data = dom.getElementsByClassName('form-control-static');

    if (data == null) return null;

    Map<String, dynamic> personalData = Map<String, dynamic>();

    personalData['register'] = data[0].text;
    personalData['name'] = data[1].text;
    personalData['viewName'] = personalData['name'].split(' ')[0];
    personalData['program'] = data[3].text.split(' (')[0].split('- ')[1];
    personalData['campus'] = data[3].text.split('(')[1].split(')')[0];

    List<String> date = data[12].text.split('/');
    DateTime birthDate = DateTime(
        int.tryParse(date[2]), int.tryParse(date[1]), int.tryParse(date[0]));

    personalData['birthDate'] = birthDate;

    personalData['gender'] = data[13].text[0];

    return personalData;
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
      'birthDate': personalData['birthDate'],
      'campus': personalData['campus'],
      'gender': personalData['gender'],
      'program': personalData['program'],
    };
  }

  Map<String, dynamic> _sanitizeProfile(Map<String, Document> dom) {
    Map<String, String> homeInfo = _sanitizeHomeInfo(dom['inicio']);
    Map<String, dynamic> personalData =
        _sanitizePersonalData(dom['cadastro'].body);

    return _buildProfile(personalData, homeInfo);
  }

  Future<Map<String, dynamic>> getCourses() async {
    Map<String, Document> _dom;

    try {
      _dom = await _requestDOMCourses();
    } catch (e) {
      rethrow;
    }

    if (_dom == null) return null;

    final data = {
      'courses': _sanitizeCourses(_dom['rdm']),
    };

    return data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    Map<String, Document> _dom;

    try {
      print('get dom');
      _dom = await _requestDOMProfile();
    } catch (e) {
      rethrow;
    }

    print('ok dom');
    if (_dom == null) return null;
    print('go sanitize');
    final profile = {
      'profile': _sanitizeProfile(_dom),
    };
    print('back from sanitize');
    return profile;
  }

  Future<Map<String, dynamic>> getAllData() async {
    Map<String, Document> _dom;

    try {
      _dom = await _requestDOM();
    } catch (e) {
      rethrow;
    }

    if (_dom == null) return null;

    final data = {
      'profile': _sanitizeProfile(_dom),
      'courses': _sanitizeCourses(_dom['rdm']),
    };

    return data;
  }
}

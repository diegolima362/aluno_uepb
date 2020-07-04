import 'package:erdm/controller/session.dart';
import 'package:erdm/models/course.dart';
import 'package:erdm/models/profile.dart';
import 'package:erdm/models/schedule.dart';
import 'package:html/dom.dart';

Future<List<Document>> requestDOM({user: String, password: String}) async {
  final String baseURL = "https://academico.uepb.edu.br/ca/index.php/alunos";
  final String loginURL =
      "https://academico.uepb.edu.br/ca/index.php/usuario/autenticar";

  Map<String, String> formData = {
    'nome_usuario': user,
    'senha_usuario': password
  };

  List<Document> data = List<Document>();
  Session client = Session();

  // Start cookies
  await client.get(baseURL);
  try {
    await client.post(loginURL, formData);
  } catch (e) {
    print(e);
    rethrow;
  }

  data.add(await client.get(baseURL));
  data.add(await client.get(baseURL + '/rdm'));
  data.add(await client.get(baseURL + '/cadastro'));

  return data;
}

/// Extract absences for all courses at once.
List<int> _extractAbsences(Document dom) {
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

List<Schedule> _extractSchedule(Element e) {
  List<Schedule> schedule = List<Schedule>();

  RegExp regExp = new RegExp(r"<i(.*?)<\/i>");
  RegExp regExp2 = new RegExp(r"[\n\t]");

  List<String> str =
      e.innerHtml.replaceAll(regExp, '').replaceAll(regExp2, '').split('<br>');

  str.forEach((element) {
    if (element.length > 1) {
      List<String> t = element.trim().split(' - ');
      List<String> dayTime = t[0].split(' ');

      String day = dayTime[0].toUpperCase();
      String time = dayTime[1];

      String local = t[1].split(': ')[1];

      schedule.add(Schedule(day: day, time: time, local: local));
    }
  });

  return schedule;
}

Course _buildCourse(Element e) {
  String title = e.getElementsByTagName('h2')[0].text.trim();
  String id = e.getElementsByTagName('p')[0].text.trim();

  List<Element> data = e.getElementsByTagName('li');

  if (data.length < 5) {
    data.insert(1, Element.html('<p>SEM PROFESSOR</p>'));
  }

  int ch = int.tryParse(data[0].text.split(' ')[3]);
  String instructor = data[1].text;
  List<Schedule> schedule = _extractSchedule(data[2]);

  Course c = Course(
    id: id,
    title: title,
    instructor: instructor,
    ch: ch,
    schedule: schedule,
  );

  return c;
}

List<Course> _extractCourses(Document dom) {
  List<Element> data = dom.getElementsByTagName('.profile-nav');
  List<Course> courses = List<Course>();

  List<int> absences = _extractAbsences(dom);

  data.forEach((e) {
    courses.add(_buildCourse(e));
  });

  for (int i = 0; i < courses.length; i++) {
    courses[i].absences = absences[i];
  }

  return courses;
}

Map<String, String> _extractHomeInfo(Document dom) {
  Map<String, String> homeInfo = Map<String, String>();
  homeInfo['cra'] = dom.querySelector('.text-purple')?.text;
  homeInfo['ch'] = dom.querySelector('.ch')?.text;

  return homeInfo;
}

Map<String, dynamic> _extractPersonalData(Document dom) {
  List<Element> data = dom.querySelectorAll('p.form-control-static');

  if (data == null) return null;

  Map<String, dynamic> personalData = Map<String, dynamic>();

  personalData['register'] = data[0].text;
  personalData['name'] = data[1].text;
  personalData['viewName'] = personalData['name'].split(' ')[0];
  personalData['program'] = data[3].text.split(' (')[0];
  personalData['campus'] = data[3].text.split('(')[1].split(')')[0];

  List<String> date = data[12].text.split('/');
  DateTime birthDate = DateTime(
      int.tryParse(date[2]), int.tryParse(date[1]), int.tryParse(date[0]));

  personalData['birthDate'] = birthDate;

  personalData['gender'] = data[13].text[0];

  return personalData;
}

Profile _buildProfile(
  Map<String, dynamic> personalData,
  Map<String, String> homeInfo,
  List<Course> courses,
) {
  return Profile(
    personalData['name'],
    personalData['register'],
    courses: courses,
    cra: homeInfo['cra'],
    cumulativeCh: homeInfo['ch'],
    viewName: personalData['viewName'],
    birthDate: personalData['birthDate'],
    campus: personalData['campus'],
    gender: personalData['gender'],
    program: personalData['program'],
  );
}

Profile extractProfile(List<Document> dom) {
  Map<String, String> homeInfo = _extractHomeInfo(dom[0]);
  List<Course> courses = _extractCourses(dom[1]);
  Map<String, dynamic> personalData = _extractPersonalData(dom[2]);

  return _buildProfile(personalData, homeInfo, courses);
}

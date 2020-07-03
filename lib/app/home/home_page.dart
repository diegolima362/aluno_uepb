import 'package:erdm/controller/scraper.dart';
import 'package:erdm/models/course.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/dom.dart' as html;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Início',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: () async => _getRemoteData(),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('courses').listenable(),
      builder: (context, box, widget) {
        final data = box.get('courses') as List;
        final courses = List<Course>();
        data.forEach((element) {
          courses.add(Course.fromMap(element));
        });

        return ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final today = DateTime.now();
            final days = courses[index].schedule.map((e) => e.weekDay).toList();
            final contains = days.indexOf(today.weekday);
            final int indexDay = contains == -1 ? 0 : contains;

            if (contains == -1) return Container();

            return _buildCard(courses[index], indexDay);
          },
        );
      },
    );
  }

  Widget _buildCard(Course course, int indexDay) {
    return Card(
      color: Color(0xFFEEEEEE),
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.width / 4.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              course.title.toUpperCase(),
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF3E206D),
              ),
            ),
            Text(
              course.instructor.toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF000000),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course.schedule[0].local,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10.0,
                  ),
                ),
                Text(
                  course.schedule[indexDay].time,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Box _getLocalData(String boxName) {
    return Hive.box(boxName);
  }

  Future<Box> _getRemoteData() async {
    List<html.Document> dom =
        await requestDOMFake(baseURL: 'http://192.168.0.103:8000');

    List<Course> courses = extractProfile(dom).courses;

    final mapCourses = List<Map<String, dynamic>>();

    courses.forEach((element) {
      mapCourses.add(element.toMap());
    });

    final box = Hive.box('courses');
    await box.clear();
    print('> saving data');
    box.put('courses', mapCourses);

    return box;
  }

  Future<void> _clearData(String boxName) async {
    await Hive.box(boxName).clear();
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}

//final course = Course.fromMap(courseBox.getAt(index));
//final today = DateTime.now();
//final days = course.schedule
//    .map((e) =>
//weekDays[e.day.substring(0, 3).toLowerCase()])
//    .toList();
//final contains = days.indexOf(today.weekday);
//final int indexDay = contains == -1 ? 0 : contains;
//
//if (
//!
//days.contains(today.weekday))
//return
//
//Container();

//

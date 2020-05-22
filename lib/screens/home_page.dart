import 'package:erdm/load_info.dart';
import 'package:erdm/models/course.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses = getData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('eRDM'),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1.0,
              horizontal: 4.0,
            ),
            child: Card(
              child: ListTile(
                onTap: () {},
                leading: Icon(Icons.library_books),
                title: Text(
                  courses[index].title,
                ),
                subtitle: Text(
                  courses[index].instructor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

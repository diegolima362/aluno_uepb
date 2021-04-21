import 'package:aluno_uepb/app/modules/home_content/home_content_page.dart';
import 'package:aluno_uepb/app/modules/profile/profile_page.dart';
import 'package:aluno_uepb/app/modules/rdm/rdm_page.dart';
import 'package:aluno_uepb/app/modules/reminders/reminders_page.dart';
import 'package:aluno_uepb/app/shared/models/course_model.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final _pages = [
    HomeContentPage(),
    RdmPage(),
    RemindersPage(),
    ProfilePage(),
  ];

  final _items = [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: 'RDM',
      icon: Icon(Icons.menu_outlined),
      activeIcon: Icon(Icons.menu),
    ),
    BottomNavigationBarItem(
      label: 'Lembretes',
      icon: Icon(Icons.assignment_outlined),
      activeIcon: Icon(Icons.assignment),
    ),
    BottomNavigationBarItem(
      label: 'Perfil',
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
    ),
  ];

  PageController? _pageController;

  List<CourseModel>? courses;

  @override
  Widget build(BuildContext context) {
    final storage = Modular.get<ILocalStorage>();

    storage.getCourses().then((value) => setState(() {
          courses = value;
        }));

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: courses?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(courses![index].name),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: controller.currentIndex,
    );
  }

  bool _onWillPop() {
    if (_pageController!.page!.round() == _pageController!.initialPage)
      return true;
    else {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      return false;
    }
  }
}

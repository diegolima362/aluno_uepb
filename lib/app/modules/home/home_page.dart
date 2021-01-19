import 'package:aluno_uepb/app/modules/home_content/home_content_module.dart';
import 'package:aluno_uepb/app/modules/profile/profile_module.dart';
import 'package:aluno_uepb/app/modules/rdm/rdm_module.dart';
import 'package:aluno_uepb/app/modules/reminders/reminders_module.dart';
import 'package:aluno_uepb/app/shared/components/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final _pages = [
    HomeContentModule(),
    RdmModule(),
    RemindersModule(),
    ProfileModule(),
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

  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (controller.loading)
          return LoadingPage();
        else
          return WillPopScope(
            onWillPop: () => Future.sync(_onWillPop),
            child: Scaffold(
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.subtitle1.color,
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.only(top: .1),
                child: BottomNavigationBar(
                  elevation: 20,
                  currentIndex: controller.currentIndex,
                  items: _items,
                  selectedItemColor: Theme.of(context).iconTheme.color,
                  unselectedItemColor: Theme.of(context).disabledColor,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  iconSize: 28,
                  onTap: (index) => _pageController.jumpToPage(index),
                ),
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: controller.updateCurrentIndex,
                children: _pages,
              ),
            ),
          );
      },
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
    if (_pageController.page.round() == _pageController.initialPage)
      return true;
    else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      return false;
    }
  }
}

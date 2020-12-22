import 'package:aluno_uepb/app/modules/profile/profile_module.dart';
import 'package:aluno_uepb/app/modules/rdm/rdm_module.dart';
import 'package:aluno_uepb/app/modules/reminders/reminders_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_content/home_content_page.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Tab/Bottom-Bar with Modular and MobX"})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final _pages = [
    HomeContentPage(),
    RdmModule(),
    RemindersModule(),
    ProfileModule(),
  ];

  final _items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'RDM'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Lembretes'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
  ];

  PageController _pageController;

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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => WillPopScope(
        onWillPop: () => Future.sync(_onWillPop),
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex,
            items: _items,
            selectedItemColor: Theme.of(context).iconTheme.color,
            unselectedItemColor: Theme.of(context).disabledColor,
            showUnselectedLabels: true,
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: controller.updateCurrentIndex,
            children: _pages,
          ),
        ),
      ),
    );
  }
}

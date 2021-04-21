import 'package:aluno_uepb/app/modules/home/controllers/controllers.dart';
import 'package:aluno_uepb/app/modules/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final _navbarItems = [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      tooltip: 'Home',
    ),
    BottomNavigationBarItem(
      label: 'RDM',
      icon: Icon(Icons.menu_outlined),
      activeIcon: Icon(Icons.menu),
      tooltip: 'RDM',
    ),
    BottomNavigationBarItem(
      label: 'Lembretes',
      icon: Icon(Icons.assignment_outlined),
      activeIcon: Icon(Icons.assignment),
      tooltip: 'Lembretes',
    ),
    BottomNavigationBarItem(
      label: 'Perfil',
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      tooltip: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPop),
      child: Observer(builder: (_) {
        if (controller.loading) return LoadingPage();
        return Scaffold(
          body: RouterOutlet(),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      }),
    );
  }

  Widget _bottomNavigationBar() {
    return Observer(builder: (_) {
      return Container(
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .4,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex,
          items: _navbarItems,
          onTap: controller.onTap,
          elevation: 20,
          selectedItemColor: Theme.of(context).iconTheme.color,
          unselectedItemColor: Theme.of(context).disabledColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          iconSize: 28,
        ),
      );
    });
  }
}

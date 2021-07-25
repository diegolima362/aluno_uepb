import 'package:aluno_uepb/app/shared/components/empty_content.dart';
import 'package:aluno_uepb/app/shared/components/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';
import 'routes.dart' as pages;

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
      icon: Icon(Icons.home_filled),
      tooltip: 'Home',
    ),
    BottomNavigationBarItem(
      label: 'RDM',
      icon: Icon(Icons.menu),
      tooltip: 'RDM',
    ),
    BottomNavigationBarItem(
      label: 'Lembretes',
      icon: Icon(Icons.assignment),
      tooltip: 'Lembretes',
    ),
    BottomNavigationBarItem(
      label: 'Perfil',
      icon: Icon(Icons.person),
      tooltip: 'Perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return WillPopScope(
        onWillPop: () => Future.sync(onWillPop),
        child: Scaffold(
          bottomNavigationBar: _bottomNavigationBar(),
          body: SafeArea(child: _buildBody()),
        ),
      );
    });
  }

  Widget _buildBody() {
    if (controller.isLoading) {
      return LoadingIndicator(text: 'Carregando');
    } else if (controller.hasError) {
      return EmptyContent(
        title: 'Erro',
        message: 'Erro ao obter os dados',
      );
    } else {
      return RouterOutlet();
    }
  }

  Widget? _bottomNavigationBar() {
    if (controller.isLoading || controller.hasError)
      return null;
    else
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
          onTap: onTap,
          elevation: 20,
          selectedItemColor: Theme.of(context).iconTheme.color,
          unselectedItemColor: Theme.of(context).disabledColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          iconSize: 28,
        ),
      );
  }

  void onTap(int id) {
    controller.updateIndex(id);
    if (id == 0) {
      Modular.to.navigate('/home/' + pages.TODAY_SCHEDULE_PAGE);
    } else if (id == 1) {
      Modular.to.navigate('/home/' + pages.RDM_PAGE);
    } else if (id == 2) {
      Modular.to.navigate('/home/' + pages.TASKS_PAGE);
    } else if (id == 3) {
      Modular.to.navigate('/home/' + pages.PROFILE_PAGE);
    }
  }

  bool onWillPop() {
    if (controller.currentIndex == 0)
      return true;
    else {
      Modular.to.navigate('/home/' + pages.TODAY_SCHEDULE_PAGE);
      controller.updateIndex(0);
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex == 0) {
          return true;
        } else {
          Modular.to.navigate('/root/courses/');
          setState(() => currentIndex = 0);
          return false;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: const RouterOutlet(),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_filled),
              label: 'Início',
              tooltip: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.library_books),
              label: 'RDM',
              tooltip: 'RDM',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Perfil',
              tooltip: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  void onDestinationSelected(int index) {
    if (index == 0) {
      Modular.to.navigate('/root/courses/');
    } else if (index == 1) {
      Modular.to.navigate('/root/courses/rdm');
    } else if (index == 2) {
      Modular.to.navigate('/root/preferences/');
    }

    setState(() => currentIndex = index);
  }
}

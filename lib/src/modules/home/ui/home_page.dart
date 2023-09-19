import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../shared/domain/extensions/build_context_extensions.dart';
import '../../../shared/external/datasources/implementations.dart';
import '../../auth/atoms/auth_atom.dart';
import '../../courses/ui/pages/pages.dart';
import '../../preferences/atoms/preferences_atom.dart';
import '../../profile/domain/atoms/profile_atom.dart';
import '../../profile/ui/profile_avatar.dart';
import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: currentPage);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.value != null) {
        fetchProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final implementation = context.select(() => implementationState.value);
    final spec = context.select(() => protocolSpecState.value);
    final profile = context.select(() => profileState.value);

    final title = implementation == DataSourceImplementation.openProtocol
        ? spec?.title ?? ''
        : implementation.title;

    return WillPopScope(
      onWillPop: () async {
        if (currentPage == 0) {
          return true;
        } else {
          setState(() => currentPage = 0);
          _controller.jumpTo(0);

          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title.split(' ').first.toLowerCase(),
            textAlign: TextAlign.start,
            style: context.textTheme.titleLarge?.copyWith(
              letterSpacing: -1,
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),
          ),
          centerTitle: true,
          actions: [
            if (profile != null)
              ProfileAvatar(
                profile: profile,
              ),
          ],
        ),
        body: PageView.builder(
          controller: _controller,
          onPageChanged: (index) => setState(() => currentPage = index),
          itemCount: 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const TodaysSchedulePage();
            } else if (index == 1) {
              return const CoursesPage();
            } else {
              return const CoursesPage();
            }
          },
        ),
        drawer: const AppDrawer(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPage,
          onDestinationSelected: (index) {
            setState(() => currentPage = index);
            if (index == 0) {
              _controller.jumpToPage(0);
            } else if (index == 1) {
              _controller.jumpToPage(1);
            } else {
              _controller.jumpToPage(0);
            }
          },
          destinations: const [
            NavigationDestination(
              label: 'Hoje',
              icon: Icon(Icons.home_filled),
            ),
            NavigationDestination(
              icon: Icon(Icons.school),
              label: 'Cursos',
            ),
            // NavigationDestination(
            //   icon: Icon(Icons.library_books_sharp),
            //   label: 'Lembretes',
            // ),
          ],
        ),
      ),
    );
  }
}

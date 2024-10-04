import 'dart:ui';

import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../interactor/actions/profile_actions.dart';
import '../../interactor/atoms/auth_atoms.dart';
import '../../interactor/atoms/profile_atoms.dart';
import '../components/components.dart';
import 'courses_page.dart';
import 'today_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HookStateMixin {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.state != null) {
        fetchProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final compact = size.width < 600 || size.height < 840;
    final medium = size.width >= 600 && size.width < 840;
    final expanded = size.width >= 840;



    final controller = usePageController();

    void onDestinationSelected(int index) {
      setState(() => index = index);
      if (index == 0) {
        controller.jumpToPage(0);
      } else if (index == 1) {
        controller.jumpToPage(1);
      } else {
        controller.jumpToPage(0);
      }
    }



    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (canPop, _) {
        if (!canPop) {
          controller
              .animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )
              .then((_) => setState(() => selectedIndex = 0));
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            if (!compact)
              AppNavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
              ),
            Expanded(
              child: PageView.builder(
                 controller: controller,
                 onPageChanged: (index) =>
                     setState(() => selectedIndex = index),
                 itemCount: 2,
                 itemBuilder: (context, index) {
                   if (index == 0) {
                     return const TodaySchedulePage();
                   } else if (index == 1) {
                     return const CoursesPage();
                   } else {
                     return const CoursesPage();
                   }
                 },
               ),
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: AppNavBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        ),
        drawer: compact ? const AppDrawer() : null,
      ),
    );
  }
}

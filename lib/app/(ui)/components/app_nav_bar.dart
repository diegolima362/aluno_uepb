import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/extensions/extensions.dart';

class AppNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          backgroundColor: context.colors.surface.withOpacity(0.002),
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              label: 'Aulas',
              icon: Icon(Symbols.today_sharp),
              selectedIcon: Icon(
                Symbols.today_sharp,
                fill: 1,
              ),
            ),
            NavigationDestination(
              label: 'Cursos',
              icon: Icon(Symbols.library_books),
              selectedIcon: Icon(
                Symbols.library_books,
                fill: 1,
              ),
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

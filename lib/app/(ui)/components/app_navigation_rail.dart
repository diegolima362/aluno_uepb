import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/extensions/extensions.dart';

class AppNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: context.colors.onSurface,
            width: 0.1,
          ),
        ),
      ),
      child: NavigationRail(
        backgroundColor: context.colors.surface,
        labelType: NavigationRailLabelType.all,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Symbols.today),
            selectedIcon: Icon(
              Symbols.today,
              fill: 1,
            ),
            label: Text('Hoje'),
          ),
          NavigationRailDestination(
            icon: Icon(Symbols.library_books),
            selectedIcon: Icon(
              Symbols.library_books,
              fill: 1,
            ),
            label: Text('Cursos'),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

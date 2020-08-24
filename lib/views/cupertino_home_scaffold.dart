import 'package:cau3pb/themes/custom_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        border: Border.all(color: Theme.of(context).canvasColor),
        backgroundColor: Theme.of(context).canvasColor,
        items: [
          _buildItem(TabItem.today),
          _buildItem(TabItem.courses),
          _buildItem(TabItem.tasks),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      activeIcon: Icon(
        itemData.icon,
        color: CustomThemes.accentColor,
      ),
      icon: Icon(
        itemData.icon,
        color: CustomThemes.accentColor.withAlpha(100),
      ),
      title: itemData.title != null ? Text(itemData.title) : null,
    );
  }
}

import 'package:flutter/material.dart';

enum TabItem { today, tasks, account }

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({this.title, @required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.today: TabItemData(icon: Icons.home),
    TabItem.tasks: TabItemData(icon: Icons.view_headline),
    TabItem.account: TabItemData(icon: Icons.person),
  };
}

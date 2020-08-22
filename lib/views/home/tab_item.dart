import 'package:flutter/material.dart';

enum TabItem { today, courses, tasks, account }

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({this.title, @required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.today: TabItemData(icon: Icons.home),
    TabItem.courses: TabItemData(icon: Icons.view_headline),
    TabItem.tasks: TabItemData(icon: Icons.assignment),
    TabItem.account: TabItemData(icon: Icons.person),
  };
}

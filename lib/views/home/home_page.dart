import 'package:aluno_uepb/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/cupertino_home_scaffold.dart';
import 'home.dart';
import '../loading/loading_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.today;
  bool _isLoading = false;

  final Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.today: GlobalKey<NavigatorState>(),
    TabItem.courses: GlobalKey<NavigatorState>(),
    TabItem.tasks: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get _widgetBuilders {
    return {
      TabItem.today: (_) => TodaySchedulePage(),
      TabItem.courses: (context) => AllCoursesPage(),
      TabItem.tasks: (context) => AllTasksPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (_currentTab == tabItem) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Future<void> _allDataReady(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final data = await database.getAllData();
    if (data != null) setState(() => _isLoading = false);
  }

  @override
  void initState() {
    _isLoading = true;
    _allDataReady(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_currentTab].currentState.maybePop(),
      child: Localizations(
        locale: const Locale('en', 'US'),
        delegates: <LocalizationsDelegate<dynamic>>[
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading)
      return LoadingPage();
    else
      return CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: _widgetBuilders,
        navigatorKeys: _navigatorKeys,
      );
  }
}

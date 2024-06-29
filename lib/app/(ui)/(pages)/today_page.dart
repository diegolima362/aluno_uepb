import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../interactor/actions/profile_actions.dart';
import '../../interactor/actions/schedule_actions.dart';
import '../../interactor/atoms/schedule_atoms.dart';
import '../components/components.dart';

class TodaySchedulePage extends StatefulWidget {
  const TodaySchedulePage({super.key});

  @override
  State<TodaySchedulePage> createState() => _TodaySchedulePageState();
}

class _TodaySchedulePageState extends State<TodaySchedulePage>
    with HookStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSchedule();
      fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useAtomState(scheduleLoadingState);
    final schedule = useAtomState(todayScheduleState);

    Widget body;
    if (isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (schedule.isEmpty) {
      body = const EmptyCollection(
        text: 'Sem aulas hoje',
        icon: Symbols.today_sharp,
      );
    } else {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        itemCount: schedule.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: ScheduleTile(info: schedule[index]),
        ),
      );
    }

    return body;
  }
}

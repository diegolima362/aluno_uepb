import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../interactor/actions/schedule_actions.dart';
import '../../interactor/atoms/schedule_atoms.dart';
import '../../interactor/models/models.dart';
import '../components/components.dart';

class FullSchedulePage extends StatefulWidget {
  const FullSchedulePage({super.key});

  @override
  State<FullSchedulePage> createState() => _FullSchedulePageState();
}

class _FullSchedulePageState extends State<FullSchedulePage>
    with HookStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useAtomState(scheduleLoadingState);
    final schedule = useAtomState(scheduleState);

    late Widget body;

    if (isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (schedule.isEmpty) {
      body = const EmptyCollection(
        text: 'Sem Aulas Registradas',
        icon: Icons.history,
      );
    } else {
      final height = MediaQuery.of(context).size.height - kToolbarHeight;
      final cardHeight = height * .9;

      body = PageView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cardHeight * .4,
                maxHeight: cardHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ScheduleAtWeekDayCard(
                  weekday: index + 1,
                  schedule: schedule[index + 1]?.schedule ?? [],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horário'),
      ),
      body: body,
    );
  }
}

class ScheduleAtWeekDayCard extends StatelessWidget {
  final int weekday;
  final List<ScheduleItem> schedule;

  const ScheduleAtWeekDayCard({
    super.key,
    required this.weekday,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            intToWeekDayEEEE(weekday),
            style: context.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 16),
        schedule.isEmpty
            ? SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'Sem aulas',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: schedule
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: ScheduleTile(info: s),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
      ],
    );
  }
}

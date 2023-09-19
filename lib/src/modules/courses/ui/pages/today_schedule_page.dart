import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../../shared/domain/extensions/extensions.dart';
import '../../../auth/atoms/auth_atom.dart';
import '../../../profile/domain/atoms/profile_atom.dart';
import '../atoms/today_schedule_atom.dart';
import '../components/schedule_tile.dart';

class TodaysSchedulePage extends StatefulWidget {
  const TodaysSchedulePage({super.key});

  @override
  State<TodaysSchedulePage> createState() => _TodaysSchedulePageState();
}

class _TodaysSchedulePageState extends State<TodaysSchedulePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      todayScheduleResultState.addListener(resultListener);
      fetchTodayScheduleAction();
      fetchProfile();
    });
  }

  void resultListener() {
    final result = todayScheduleResultState.value;

    if (result != null) {
      result.fold(
        (message) {
          context.showMessage(message, resetResult);
        },
        (error) {
          if (error.code == 'anti_span') {
            context.showErrorWithAction(
              error.message,
              onClosed: resetResult,
              label: 'Entrar',
              onPressed: resetAuthAction,
            );
          } else {
            context.showError(error.message, resetResult);
          }
        },
      );
    }
  }

  void resetResult() {
    todayScheduleResultState.value = null;
  }

  @override
  void dispose() {
    todayScheduleResultState.removeListener(resultListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                today.dayOfWeek.capitalFirst,
                style: context.textTheme.titleLarge,
              ),
              Text(
                today.simpleDate,
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: RxBuilder(
            builder: (context) {
              final isLoading = todayScheduleLoadingState.value;
              final schedule = todayScheduleState.value;

              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (schedule.isEmpty) {
                return Center(
                  child: Text(
                    'Sem Aulas Hoje',
                    style: context.textTheme.titleLarge,
                  ),
                );
              } else {
                return ListView.builder(
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
            },
          ),
        ),
      ],
    );
  }
}

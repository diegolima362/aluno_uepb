import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../../shared/domain/extensions/extensions.dart';
import '../../../../shared/ui/widgets/empty_collection.dart';
import '../../models/models.dart';
import '../atoms/full_schedule_atom.dart';
import '../components/schedule_tile.dart';

class FullSchedulePage extends StatefulWidget {
  const FullSchedulePage({super.key});

  @override
  State<FullSchedulePage> createState() => _FullSchedulePageState();
}

class _FullSchedulePageState extends State<FullSchedulePage> {
  late final ScrollController verticalController;

  @override
  void initState() {
    super.initState();

    verticalController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fullScheduleResultState.addListener(resultListener);
      fetchFullScheduleAction();
    });
  }

  void resultListener() {
    final result = fullScheduleResultState.value;
    if (result != null) {
      result.fold(
        (message) {
          context.showMessage(message, resetResult);
        },
        (error) {
          context.showError(error.message, resetResult);
        },
      );
    }
  }

  void resetResult() {
    fullScheduleResultState.value = null;
  }

  @override
  void dispose() {
    fullScheduleResultState.removeListener(resultListener);

    verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(() => fullScheduleLoadingState.value);
    context.select(() => fullScheduleState.value.length);

    final schedule = fullScheduleState.value;

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
        itemCount: schedule.length,
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
                child: ScheduleAtWeekDayCard(info: schedule[index]),
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
  final ScheduleAtWeekDay info;

  const ScheduleAtWeekDayCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final (weekday, schedule) = info;

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

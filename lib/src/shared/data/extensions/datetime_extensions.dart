import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'string_extensions.dart';

extension DateFormater on DateTime {
  String get hours => DateFormat.Hm().format(this);

  String get date =>
      '${DateFormat('E', 'pt_Br').format(this)}, ${DateFormat('MMMMd', 'pt_Br').format(this)}';

  String get completeDate => DateFormat('E, d MMM y', 'pt_Br').format(this);

  String get simpleDate => DateFormat('d MMM y', 'pt_Br').format(this);

  String get formDate => DateFormat.yMd('pt_Br').format(this);

  String get fullDate => DateFormat.yMMMMd('pt_Br').format(this);

  String get fullDayDate =>
      '${DateFormat('EEEE', 'pt_Br').format(this)}, ${DateFormat('yMMMMd', 'pt_Br').format(this)}';

  String get dayOfWeek => DateFormat.EEEE('pt_Br').format(this);

  String get dateFirebase =>
      DateFormat('dMMMy').format(this).replaceAll('/', ' ');
}

extension FormatDaysAfter on DateTime {
  String get formatDaysAfter {
    final duration = Duration(
            microseconds: now.microsecondsSinceEpoch - microsecondsSinceEpoch)
        .inDays;

    return duration == 0 && day == now.day
        ? 'Hoje'
        : duration == 0
            ? 'Ontem'
            : duration < 7
                ? '$dayOfWeek • $simpleDate'
                : simpleDate;
  }
}

extension ToDateTime on TimeOfDay {
  DateTime get asDateTime {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day, hour, minute);
  }

  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

extension ThisWeek on DateTime {
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int get weekNumber {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(year - 1);
    } else if (woy > numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  DateTime get now => DateTime.now();

  DateTime get yesterday => now.subtract(const Duration(days: 1));

  bool get isYesterday => sameDay(yesterday);

  bool sameDay(DateTime o) =>
      o.day == day && o.month == month && o.year == year;

  bool get isToday => sameDay(now);

  bool get thisWeek => isInWeek(DateTime.now());

  bool isInWeek(DateTime other) =>
      weekNumber == other.weekNumber && year == other.year;

  bool get lastWeek =>
      isAfter(DateTime.now().subtract(const Duration(days: 7)));
}

String intToWeekDayE(int val) => DateFormat.E('pt_BR')
    .format(
      DateTime.now().subtract(
        Duration(
          days: DateTime.now().weekday - val,
        ),
      ),
    )
    .capitalFirst;

String intToWeekDayEEEE(int val) => DateFormat.EEEE('pt_BR')
    .format(
      DateTime.now().subtract(
        Duration(
          days: DateTime.now().weekday - val,
        ),
      ),
    )
    .capitalFirst;

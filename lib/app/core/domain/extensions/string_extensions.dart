extension StringFormater on String {
  static const diacritics =
      'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  static const nonDiacritics =
      'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  String get withoutDiacriticalMarks => splitMapJoin('',
      onNonMatch: (char) => char.isNotEmpty && diacritics.contains(char)
          ? nonDiacritics[diacritics.indexOf(char)]
          : char);

  String get capitalString {
    final s = StringBuffer();

    if (contains('-')) {
      toLowerCase().split('-').forEach((i) => s.write(
            i.length == 1
                ? i.toUpperCase() + ' '
                : i.length > 2
                    ? i[0].toUpperCase() + i.substring(1) + '-'
                    : i + ' ',
          ));

      return s.toString().substring(0, s.length - 1).trim();
    } else {
      toLowerCase().split(' ').forEach((i) => s.write(i.length == 1
          ? i.toUpperCase() + ' '
          : i.length > 2
              ? i[0].toUpperCase() + i.substring(1) + ' '
              : i + ' '));

      return s.toString().trim();
    }
  }

  String get capitalFirst =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
}

extension TimeStamp on String {
  static RegExp regExp = RegExp(
    r"(\d?\d:)?([0-5]?\d):([0-5]\d)",
    caseSensitive: false,
    multiLine: false,
  );

  bool get hasTimesStamps => regExp.hasMatch(this);

  int get timeStampsCount => getTimesTamps.length;

  Duration? get strToTimestamp {
    final group = split(':');

    if (group.length < 2) return null;

    final h = group.length == 3 ? (int.tryParse(group[0]) ?? 0) : 0;
    final m = int.tryParse(group[group.length == 3 ? 1 : 0]) ?? 0;
    final s = int.tryParse(group[group.length == 3 ? 2 : 1]) ?? 0;

    return Duration(hours: h, minutes: m, seconds: s);
  }

  String get labelTimeStamps => splitMapJoin(
        TimeStamp.regExp,
        onMatch: (m) => '\$TS${m.group(0) ?? ''}\$TS',
        onNonMatch: (s) => s,
      );

  List<String?> get getTimesTamps =>
      regExp.allMatches(this).map((m) => m[0]).toList();

  List<Duration> get getTimesStamp {
    final list = <Duration>[];

    if (!hasTimesStamps) return list;

    final times = getTimesTamps;

    for (var t in times) {
      if (t == null) continue;
      final durataion = t.strToTimestamp;
      if (durataion != null) list.add(durataion);
    }

    return list;
  }
}

extension URL on String {
  static RegExp regExp = RegExp(
    r"[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-ZÀ-ú0-9@:%_\+.~#?&//=]*)?",
    caseSensitive: false,
    multiLine: false,
  );

  bool get hasURL => regExp.hasMatch(this);

  int get urlCount => getUrls.length;

  String get labelUrl => splitMapJoin(
        regExp,
        onMatch: (m) => '\$TS${m.group(0) ?? ''}\$TS',
        onNonMatch: (s) => s,
      );

  List<String?> get getUrls =>
      regExp.allMatches(this).map((m) => m[0]).toList();

  List<String> get getUrl {
    final list = <String>[];

    if (!hasURL) return list;

    final url = getUrls;

    for (var u in url) {
      if (u == null) continue;
      list.add(u);
    }

    return list;
  }
}

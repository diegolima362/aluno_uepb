extension TimeFormat on Duration {
  static RegExp time = RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$');

  String get timeFormat => time.firstMatch("$this")?.group(1) ?? '$this';

  String get formatTime {
    return inHours >= 1
        ? '${inHours}h ${inMinutes % 60} min'
        : inMinutes >= 1
            ? '$inMinutes min'
            : '$inSeconds seg';
  }
}

extension HumanizedDuration on Duration {
  String toHumanizedString() {
    final seconds = '${inSeconds % 60}'.padLeft(2, '0');
    String minutes = '${inMinutes % 60}';
    if (inHours > 0 || inMinutes == 0) {
      minutes = minutes.padLeft(2, '0');
    }
    String value = '$minutes:$seconds';
    if (inHours > 0) {
      value = '$inHours:$minutes:$seconds';
    }
    return value;
  }
}

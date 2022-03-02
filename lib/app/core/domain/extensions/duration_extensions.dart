extension TimeFormat on Duration {
  static RegExp time = RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$');
  String get timeFormat => time.firstMatch("$this")?.group(1) ?? '$this';
}

import 'dart:io';
import 'dart:math';

extension FileSize on File {
  static const suffixes = ["B", "KB", "MB", "GB"];

  String get getFileSize {
    int bytes = lengthSync();
    if (bytes <= 0) return "0 B";

    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}

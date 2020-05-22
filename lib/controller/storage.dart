import 'dart:io';

class ProfileStorage {
  static final ProfileStorage _singleton = ProfileStorage._internal();

  factory ProfileStorage() {
    return _singleton;
  }

  ProfileStorage._internal();

  Future<File> localFile(String fileName) async {
    return File('$fileName');
  }

  Future<File> writeProfileInfo(String data, String fileName) async {
    final file = await localFile(fileName);

    return file.writeAsString('$data');
  }

  Future<String> readProfileInfo(String fileName) async {
    try {
      final file = await localFile(fileName);

      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'error';
    }
  }
}

import 'dart:async';

import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage/hive_storage.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/interfaces/remote_data_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/scraper/scraper.dart';
import 'package:aluno_uepb/app/utils/format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

main() async {
  final user = '';
  final pass = '';
  await Hive.initFlutter('alunoUEPB/data');
  await HiveStorage.initDatabase();
  IRemoteData scraper = Scraper(user: user, password: pass, debugMode: true);

  test('Should return same data as saved - Courses', () async {
    final originalData = (await scraper.getCourses());
    print('get originalData');
    await Future.delayed(const Duration(seconds: 5), () => print('hoy'));
    final updatedData = (await scraper.getCourses());

    if (originalData != null && updatedData != null) {
      final index = <int>[];

      for (int i = 0; i < updatedData.length; i++) {
        if (originalData[i].toString() != updatedData[i].toString())
          index.add(i);
      }

      print('changes ${index.length}');

      for (int i = 0; i < index.length; i++) {
        final c = index[i];
        final professor = Format.capitalString(originalData[c]['professor']);
        final course = Format.capitalString(originalData[c]['name']);

        if (originalData[c]['absences'] != updatedData[c]['absences']) {
          print('$professor registrou uma falta sua em $course!');
        }

        if (originalData[c]['und1Grade'] != updatedData[c]['und1Grade'] ||
            originalData[c]['und2Grade'] != updatedData[c]['und2Grade'] ||
            originalData[c]['finalTest'] != updatedData[c]['finalTest']) {
          print('Sua nota em $course foi registrada!');
        }
      }
    }
  });
}

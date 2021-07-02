import 'package:aluno_uepb/app/shared/repositories/local_storage/hive_storage/hive_storage.dart';
import 'package:aluno_uepb/app/shared/repositories/local_storage/interfaces/local_storage_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/interfaces/remote_data_interface.dart';
import 'package:aluno_uepb/app/shared/repositories/remote_data/scraper/scraper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

main() async {
  final user = '';
  final pass = '';
  await Hive.initFlutter('alunoUEPB/data');
  await HiveStorage.initDatabase();
  IRemoteData scraper = Scraper(user: user, password: pass, debugMode: true);
  ILocalStorage storage = HiveStorage();

  test('Should return same data as saved - Courses', () async {
    final data = (await scraper.getCourses());

    expect(data, isNotNull);

    await storage.saveCourses(data!);

    final restoredData = await storage.getCourses();

    expect(restoredData, isNotNull);

    for (int i = 0; i < restoredData!.length; i++) {
      expect(restoredData[i], data[i]);
    }
  });

  test('Should return same data as saved - Profile', () async {
    final data = (await scraper.getProfile());

    expect(data, isNotNull);

    await storage.saveProfile(data!);

    final restoredData = await storage.getProfile();

    expect(restoredData, isNotNull);

    expect(restoredData.toString(), data.toString());
  });

  test('Should return same data as saved - History', () async {
    final data = (await scraper.getHistory());

    expect(data, isNotNull);

    await storage.saveHistory(data!);

    final restoredData = await storage.getHistory();

    expect(restoredData, isNotNull);

    for (int i = 0; i < restoredData!.length; i++) {
      expect(restoredData[i].toString(), data[i].toString());
    }
  });
}

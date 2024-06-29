import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'sqflite_schema.dart';

late final Database sqfliteDatabase;

Future<Database> initializeSqflite() async {
  final path = p.join(await getDatabasesPath(), 'app_db.sqlite');
  sqfliteDatabase = await openDatabase(
    path,
    onCreate: _createSqlSchema,
    version: 1,
  );

  return sqfliteDatabase;
}

FutureOr<void> _createSqlSchema(Database db, int version) async {
  await db.execute(createCourses);
  await db.execute(createGrades);
  await db.execute(createSchedules);
  await db.execute(createHistory);
  await db.execute(createAssessments);
  await db.execute(createSettings);
  await db.execute(createProfiles);
  await db.execute(createAcademicIndexes);
}

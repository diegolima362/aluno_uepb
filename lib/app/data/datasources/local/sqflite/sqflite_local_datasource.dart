import 'package:sqflite/sqflite.dart';

import '../../../../interactor/datasources/academic_datasource.dart';
import '../../../../interactor/models/models.dart';
import 'parser.dart';

const _profileTable = 'profiles';
const _coursesTable = 'courses';
const _gradesTable = 'grades';
const _schedulesTable = 'schedules';
const _historyTable = 'history';
const _preferencesTable = 'preferences';
const _academicIndexesTable = 'academic_indexes';

class SqfliteLocalDataSource implements AppLocalDataSource {
  final Database db;

  SqfliteLocalDataSource(this.db);

  @override
  Future<Course?> fetchCourse(String id) async {
    final result = await db.query(
      _coursesTable,
      where: 'courseId = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) {
      return null;
    }

    final course = parseCourse(result.first);

    final gradesResult = await db.query(
      _gradesTable,
      where: 'course = ?',
      whereArgs: [course.code],
    );
    List<Grade> grades =
        gradesResult.map((e) => parseGrade(e)).toList(growable: false);

    final schedulesResult = await db.query(
      _schedulesTable,
      where: 'course = ?',
      whereArgs: [course.code],
    );
    List<Lesson> schedules =
        schedulesResult.map((e) => parseSchedule(e)).toList(growable: false);

    return course.copyWith(
      grades: grades,
      schedule: schedules,
    );
  }

  @override
  Future<List<Course>> fetchCourses() async {
    final result = await db.query(_coursesTable);
    if (result.isEmpty) {
      return [];
    }

    List<Course> courses = [];
    for (var row in result) {
      Course course = parseCourse(row);

      final gradesResult = await db
          .query(_gradesTable, where: 'course = ?', whereArgs: [course.code]);
      List<Grade> grades =
          gradesResult.map((e) => parseGrade(e)).toList(growable: false);

      final schedulesResult = await db.query(_schedulesTable,
          where: 'course = ?', whereArgs: [course.code]);
      List<Lesson> schedules =
          schedulesResult.map((e) => parseSchedule(e)).toList(growable: false);

      courses.add(course.copyWith(
        grades: grades,
        schedule: schedules,
      ));
    }

    return courses;
  }

  @override
  Future<void> cacheCourses(List<Course> data) async {
    await db.transaction((txn) async {
      for (var record in data) {
        await saveCourse(txn, record);
      }
    });
  }

  Future<void> saveCourse(Transaction txn, Course record) async {
    final map = record.toMap();
    final code = record.code;
    map['professors'] = record.professors.join(';');

    map
      ..remove('grades')
      ..remove('schedule');

    await txn.insert(
      _coursesTable,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final grades = record.grades;
    final schedule = record.schedule;

    final batch = txn.batch();

    if (grades.isNotEmpty) {
      await txn.delete(
        'grades',
        where: 'course = ?',
        whereArgs: [code],
      );

      for (final item in grades) {
        final map = item.toMap();
        map['course'] = code;
        batch.insert(
          'grades',
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    if (schedule.isNotEmpty) {
      await txn.delete(
        'schedules',
        where: 'course = ?',
        whereArgs: [code],
      );

      for (final item in schedule) {
        final map = item.toMap();
        map['course'] = code;
        batch.insert(
          'schedules',
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit(noResult: true);
  }

  @override
  Future<Profile?> fetchProfile() async {
    final data = await db.query(
      _profileTable,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (data.isEmpty) {
      return null;
    }

    final academicIndexes = await db.query(
      _academicIndexesTable,
      where: 'profile = ?',
      whereArgs: [1],
    );

    final profile = Profile.fromMap(data.first);

    return profile.copyWith(
      academicIndexes: academicIndexes
          .map((e) => AcademicIndex.fromMap(e))
          .toList(growable: false),
    );
  }

  @override
  Future<void> cacheProfile(Profile data) async {
    final map = data.toMap();
    map['id'] = 1;
    map.remove('academicIndexes');
    await db.insert(
      _profileTable,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.delete(
      _academicIndexesTable,
      where: 'profile = ?',
      whereArgs: [1],
    );

    for (final index in data.academicIndexes) {
      final map = index.toMap();
      map['profile'] = 1;
      await db.insert(
        _academicIndexesTable,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<List<HistoryEntry>> fetchHistory() async {
    final List<Map<String, dynamic>> maps = await db.query(_historyTable);

    final data = maps.map((e) => parseHistory(e)).toList(growable: false);

    return data;
  }

  @override
  Future<void> cacheHistory(List<HistoryEntry> data) async {
    await db.transaction((txn) async {
      for (var record in data) {
        final map = record.toMap();
        if (map['id'] == 0) {
          map.remove('id');
        }
        map['professors'] = record.professors.join(';');

        await txn.insert(
          _historyTable,
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<Preferences?> fetchPreferences() async {
    final data = await db.query(
      _preferencesTable,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (data.isEmpty) {
      return null;
    }

    return Preferences.fromMap(data.first);
  }

  @override
  Future<void> cachePreferences(Preferences preferences) async {
    final map = preferences.toMap();
    map['id'] = 1;

    await db.insert(
      _preferencesTable,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearData() async {
    await db.delete(_profileTable);
    await db.delete(_coursesTable);
    await db.delete(_historyTable);
    await db.delete(_preferencesTable);
  }

  @override
  Future<void> clearCourses() async {
    await db.delete(_coursesTable);
    await db.delete(_gradesTable);
    await db.delete(_schedulesTable);
  }

  @override
  Future<void> clearHistory() async {
    await db.delete(_historyTable);
  }

  @override
  Future<void> clearProfile() async {
    await db.delete(_profileTable);
  }

  @override
  Future<void> clearPreferences() async {
    await db.delete(_preferencesTable);
  }
}

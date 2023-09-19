import 'package:isar/isar.dart';

import '../domain/models/profile.dart';

part 'schema.g.dart';

@Collection()
@Name("Profile")
class IsarProfileModel {
  Id id = 1;

  String register = '';
  String name = '';
  String program = '';
  String campus = '';
  String totalHours = '';
  String credits = '';
  bool socialProfile = false;
  List<IsarAcademicIndexModel> academicIndexes = [];

  IsarProfileModel({
    this.register = '',
    this.name = '',
    this.program = '',
    this.campus = '',
    this.totalHours = '',
    this.credits = '',
    this.socialProfile = false,
    this.academicIndexes = const [],
  });

  factory IsarProfileModel.fromDomain(Profile profile) {
    return IsarProfileModel(
      register: profile.register,
      name: profile.name,
      program: profile.program,
      campus: profile.campus,
      totalHours: profile.totalHours,
      credits: profile.credits,
      socialProfile: profile.socialProfile,
      academicIndexes: profile.academicIndexes
          .map(IsarAcademicIndexModel.fromDomain)
          .toList(),
    );
  }

  Profile toDomain() => Profile(
        register: register,
        name: name,
        program: program,
        campus: campus,
        totalHours: totalHours,
        credits: credits,
        socialProfile: socialProfile,
        academicIndexes: academicIndexes.map((e) => e.toDomain()).toList(),
      );
}

@embedded
@Name("AcademicIndex")
class IsarAcademicIndexModel {
  String label;
  String value;

  IsarAcademicIndexModel({
    this.label = '',
    this.value = '',
  });

  factory IsarAcademicIndexModel.fromDomain(AcademicIndex academicIndex) {
    return IsarAcademicIndexModel(
      label: academicIndex.label,
      value: academicIndex.value,
    );
  }

  AcademicIndex toDomain() => AcademicIndex(
        label: label,
        value: value,
      );
}

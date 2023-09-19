import '../../../../shared/domain/extensions/extensions.dart';

class Profile {
  final String register;
  final String name;
  final String program;
  final String campus;
  final String totalHours;
  final String credits;
  final bool socialProfile;
  final List<AcademicIndex> academicIndexes;

  Profile({
    required this.register,
    required this.name,
    required this.program,
    required this.campus,
    required this.totalHours,
    required this.credits,
    this.socialProfile = false,
    this.academicIndexes = const [],
  });

  // copyWith
  Profile copyWith({
    String? register,
    String? name,
    String? program,
    String? campus,
    String? totalHours,
    String? credits,
    bool? socialProfile,
    List<AcademicIndex>? academicIndexes,
  }) {
    return Profile(
      register: register ?? this.register,
      name: name ?? this.name,
      program: program ?? this.program,
      campus: campus ?? this.campus,
      totalHours: totalHours ?? this.totalHours,
      credits: credits ?? this.credits,
      socialProfile: socialProfile ?? this.socialProfile,
      academicIndexes: academicIndexes ?? this.academicIndexes,
    );
  }
}

class AcademicIndex {
  final String label;
  final String value;

  AcademicIndex({
    this.label = '',
    this.value = '',
  });
}

extension Formater on Profile {
  String get firstName => name.split(' ').first.toLowerCase().capitalFirst;

  String get initials => name
      .split(' ')
      .map((e) => e.substring(0, 1).toUpperCase())
      .take(2)
      .toList()
      .join();
}

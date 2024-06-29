import '../../core/extensions/extensions.dart';

class Profile {
  final String register;
  final String name;
  final String program;
  final String campus;
  final String totalHours;
  final String credits;
  final List<AcademicIndex> academicIndexes;
  final String avatar;

  Profile({
    required this.register,
    required this.name,
    required this.program,
    required this.campus,
    required this.totalHours,
    required this.credits,
    this.academicIndexes = const [],
    this.avatar = '',
  });

  factory Profile.empty() => Profile(
        register: '',
        name: '',
        program: '',
        totalHours: '',
        credits: '',
        academicIndexes: [],
        campus: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'register': register,
      'name': name,
      'program': program,
      'campus': campus,
      'totalHours': totalHours,
      'credits': credits,
      'academicIndexes': academicIndexes.map((x) => x.toMap()).toList(),
      'avatar': avatar,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      register: map['register'] ?? '',
      name: map['name'] ?? '',
      program: map['program'] ?? '',
      campus: map['campus'] ?? '',
      totalHours: map['totalHours'] ?? '',
      credits: map['credits'] ?? '',
      academicIndexes: List<AcademicIndex>.from(
          map['academicIndexes']?.map((x) => AcademicIndex.fromMap(x)) ?? []),
      avatar: map['avatar'] ?? '',
    );
  }

  Profile copyWith({
    String? register,
    String? name,
    String? program,
    String? campus,
    String? totalHours,
    String? credits,
    List<AcademicIndex>? academicIndexes,
    String? avatar,
  }) {
    return Profile(
      register: register ?? this.register,
      name: name ?? this.name,
      program: program ?? this.program,
      campus: campus ?? this.campus,
      totalHours: totalHours ?? this.totalHours,
      credits: credits ?? this.credits,
      academicIndexes: academicIndexes ?? this.academicIndexes,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() {
    return 'Profile{register: $register, name: $name, program: $program, campus: $campus, totalHours: $totalHours, credits: $credits, academicIndexes: $academicIndexes, avatar: $avatar}';
  }
}

class AcademicIndex {
  final String label;
  final String value;

  AcademicIndex({
    this.label = '',
    this.value = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'value': value,
    };
  }

  factory AcademicIndex.fromMap(Map<String, dynamic> map) {
    return AcademicIndex(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
    );
  }

  @override
  String toString() {
    return 'AcademicIndex{label: $label, value: $value}';
  }
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

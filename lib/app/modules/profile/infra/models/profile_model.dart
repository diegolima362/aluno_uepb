import 'dart:convert';

import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required String register,
    required String name,
    required String program,
    required String campus,
    required String cra,
    required String cumulativeHours,
  }) : super(
          register: register,
          name: name,
          program: program,
          campus: campus,
          cra: cra,
          cumulativeHours: cumulativeHours,
        );

  ProfileModel copyWith({
    String? register,
    String? name,
    String? program,
    String? campus,
    String? cra,
    String? cumulativeHours,
  }) {
    return ProfileModel(
      register: register ?? this.register,
      name: name ?? this.name,
      program: program ?? this.program,
      campus: campus ?? this.campus,
      cra: cra ?? this.cra,
      cumulativeHours: cumulativeHours ?? this.cumulativeHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'register': register,
      'name': name,
      'program': program,
      'campus': campus,
      'cra': cra,
      'cumulativeHours': cumulativeHours,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      register: map['register'] ?? '',
      name: map['name'] ?? '',
      program: map['program'] ?? '',
      campus: map['campus'] ?? '',
      cra: map['cra'] ?? '',
      cumulativeHours: map['cumulativeHours'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProfileModel(register: $register, name: $name, program: $program, campus: $campus, cra: $cra, cumulativeHours: $cumulativeHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.register == register &&
        other.name == name &&
        other.program == program &&
        other.campus == campus &&
        other.cra == cra &&
        other.cumulativeHours == cumulativeHours;
  }

  @override
  int get hashCode {
    return register.hashCode ^
        name.hashCode ^
        program.hashCode ^
        campus.hashCode ^
        cra.hashCode ^
        cumulativeHours.hashCode;
  }
}

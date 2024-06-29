class HistoryEntry {
  final String code;
  final String name;
  final List<String> professors;
  final String semester;
  final String totalHours;
  final String grade;
  final String status;
  final String type;
  final String credits;

  HistoryEntry({
    required this.code,
    required this.name,
    required this.professors,
    required this.semester,
    required this.totalHours,
    required this.grade,
    required this.status,
    required this.type,
    required this.credits,
  });

  HistoryEntry copyWith({
    String? code,
    String? name,
    List<String>? professors,
    String? semester,
    String? totalHours,
    String? grade,
    String? status,
    String? type,
    String? credits,
  }) {
    return HistoryEntry(
      code: code ?? this.code,
      name: name ?? this.name,
      professors: professors ?? this.professors,
      semester: semester ?? this.semester,
      totalHours: totalHours ?? this.totalHours,
      grade: grade ?? this.grade,
      status: status ?? this.status,
      type: type ?? this.type,
      credits: credits ?? this.credits,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'professors': professors,
      'semester': semester,
      'totalHours': totalHours,
      'grade': grade,
      'status': status,
      'type': type,
      'credits': credits,
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      professors: List<String>.from(map['professors'] ?? []),
      semester: map['semester'] ?? '',
      totalHours: map['totalHours'] ?? '',
      grade: map['grade'] ?? '',
      status: map['status'] ?? '',
      type: map['type'] ?? '',
      credits: map['credits'] ?? '',
    );
  }

  List<String> get props =>
      [semester, code, name, totalHours, grade, status, type, credits];

  @override
  String toString() {
    return 'History{code: $code, name: $name, professors: $professors, semester: $semester, totalHours: $totalHours, grade: $grade, status: $status, type: $type, credits: $credits}';
  }
}

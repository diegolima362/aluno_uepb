class History {
  final int id;
  final String name;
  final List<String> professors;
  final String code;
  final String semester;
  final String totalHours;
  final String grade;
  final String status;
  final String type;
  final String credits;

  History({
    this.id = 0,
    required this.name,
    required this.professors,
    required this.code,
    required this.semester,
    required this.totalHours,
    required this.grade,
    required this.status,
    required this.type,
    required this.credits,
  });

  History copyWith({
    int? id,
    String? name,
    List<String>? professors,
    String? code,
    String? semester,
    String? totalHours,
    String? grade,
    String? status,
    String? type,
    String? credits,
  }) {
    return History(
      id: id ?? this.id,
      name: name ?? this.name,
      professors: professors ?? this.professors,
      code: code ?? this.code,
      semester: semester ?? this.semester,
      totalHours: totalHours ?? this.totalHours,
      grade: grade ?? this.grade,
      status: status ?? this.status,
      type: type ?? this.type,
      credits: credits ?? this.credits,
    );
  }
}

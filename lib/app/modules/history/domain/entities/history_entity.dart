class HistoryEntity {
  final String id;
  final String name;
  final String semester;
  final String cumulativeHours;
  final String grade;
  final String absences;
  final String status;

  HistoryEntity({
    required this.id,
    required this.name,
    required this.semester,
    required this.cumulativeHours,
    required this.grade,
    required this.absences,
    required this.status,
  });
}

import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';

import '../../../../../infra/models/models.dart';

HistoryModel historyFromTable(History history) {
  return HistoryModel(
    id: history.idDisciplina,
    name: history.name,
    semester: history.semester,
    cumulativeHours: history.cumulativeHours,
    grade: history.grade,
    absences: history.absences,
    status: history.status,
  );
}

HistoryTableCompanion historyToTable(HistoryModel history) {
  return HistoryTableCompanion.insert(
    idDisciplina: history.id,
    name: history.name,
    semester: history.semester,
    cumulativeHours: history.cumulativeHours,
    grade: history.grade,
    absences: history.absences,
    status: history.status,
  );
}

const debug = false;

const baseUrl = debug
    ? 'http://192.168.0.:8050'
    : 'https://pre.ufcg.edu.br:8443/ControleAcademicoOnline/Controlador';

const selectSemesterUrl = '$baseUrl?command=AlunoHorarioConsultar';
const scheduleUrl =
    '$baseUrl?command=AlunoHorarioConfirmar&ano={year}&periodo={semester}';

const rdmUrl = '$baseUrl?command=AlunoHorarioConsultar';

const inProgressGradesUrl =
    '$baseUrl?command=AlunoTurmaNotas&codigo={code}&turma={class}&periodo={semester}';

const inProgressAbsencesUrl =
    '$baseUrl?command=AlunoTurmaFrequencia&codigo={code}&turma={class}&periodo={semester}';

const historyUrl = '$baseUrl?command=AlunoHistorico';

const error1 = 'Matrícula inválida ou senha incorreta.';

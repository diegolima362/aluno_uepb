const debug = false;

const baseURL = debug
    ? 'http://192.168.0.:8050'
    : 'https://academico.uepb.edu.br/ca/index.php';

const loginURL = baseURL + '/usuario/autenticar';

const homeURL = baseURL + '/alunos';
const rdmURL = homeURL + '/rdm';
const rdmPrintURL = homeURL + '/imprimirRDM';
const historyURL = homeURL + '/historico';
const profileURL = homeURL + '/cadastro';
const curriculumURL = homeURL + '/gradeCurricular';

const error1 = '<p>Usuário ou senha não conferem.</p>';
const error2 = '<p>Matrícula ou senha não conferem.</p>';
const error3 = '<p>Erro inesperado na autenticação do aluno.</p>';

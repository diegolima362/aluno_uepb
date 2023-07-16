const debug = false;

const baseURL = debug
    ? 'http://192.168.0.:8050'
    : 'https://academico.uepb.edu.br/ca/index.php';

const loginURL = '$baseURL/usuario/autenticar';

const homeURL = '$baseURL/alunos';
const rdmURL = '$homeURL/rdm';
const rdmPrintURL = '$homeURL/imprimirRDM';
const historyURL = '$homeURL/historico';
const profileURL = '$homeURL/historico';
const curriculumURL = '$homeURL/gradeCurricular';

const error1 = '<p>Usuário ou senha não conferem.</p>';
const error2 = '<p>Matrícula ou senha não conferem.</p>';
const error3 = '<p>Erro inesperado na autenticação do aluno.</p>';

const errorAvaliation =
    'Assim, as funções do sistema de Controle Acadêmico estarão bloqueadas temporariamente, apenas enquanto você realiza sua avaliação.';

const avaliationMessage =
    'Prezado aluno é necessário que você realize a avaliação institucional através do portal do Controle Acadêmico. Enquanto você não realizar a avaliação não será possível acessar o sistema.';

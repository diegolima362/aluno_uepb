const _base = 'http://apisacocheiotv.herokuapp.com';

const urlAuth = _base + '/login';

const urlGetType = _base + '/usuarios/getType';

const urlGetNome = _base + '/programas';

bool checkToken(Map<String, dynamic> map) =>
    (map['userType'] ?? '') == 'USER_ASSINANTE';

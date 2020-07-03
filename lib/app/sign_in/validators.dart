abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class Validator {
  final StringValidator registerValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidRegisterErrorText = 'Matricula não pode ser vazia';
  final String invalidPasswordErrorText = 'Senha não pode ser vazia';
}

import 'package:erdm/app/sign_in/validators.dart';
import 'package:erdm/services/auth.dart';
import 'package:flutter/foundation.dart';

class SignInChangeModel with Validator, ChangeNotifier {
  final AuthBase auth;

  String register;
  String password;
  bool isLoading;
  bool submitted;
  bool registerEdited;
  bool passwordEdited;

  SignInChangeModel({
    @required this.auth,
    this.register = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
    this.registerEdited = false,
    this.passwordEdited = false,
  });

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      await auth.signInWithRegisterAndPassword(
          this.register.trim(), this.password.trim());
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  bool get canSubmit {
    return registerValidator.isValid(register) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = passwordEdited && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get registerErrorText {
    bool showErrorText = registerEdited && !registerValidator.isValid(register);
    return showErrorText ? invalidRegisterErrorText : null;
  }

  void updateRegister(String register) =>
      updateWith(register: register, registerEdited: true);

  void updatePassword(String password) =>
      updateWith(password: password, passwordEdited: true);

  void updateWith({
    String register,
    String password,
    bool isLoading,
    bool submitted,
    bool registerEdited,
    bool passwordEdited,
  }) {
    this.register = register ?? this.register;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.registerEdited = registerEdited ?? this.registerEdited;
    this.passwordEdited = passwordEdited ?? this.passwordEdited;
    notifyListeners();
  }
}

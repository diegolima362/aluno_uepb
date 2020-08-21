import 'package:cau3pb/services/services.dart';
import 'package:flutter/foundation.dart';

import 'validators.dart';

class SignInChangeModel with Validator, ChangeNotifier {
  final AuthBase auth;

  String user;
  String password;
  bool isLoading;
  bool submitted;
  bool registerEdited;
  bool passwordEdited;

  SignInChangeModel({
    @required this.auth,
    this.user = '',
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
      await auth.signInWithUserAndPassword(
          this.user.trim(), this.password.trim());
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  bool get canSubmit {
    return userValidator.isValid(user) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = passwordEdited && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get userErrorText {
    bool showErrorText = registerEdited && !userValidator.isValid(user);
    return showErrorText ? invalidRegisterErrorText : null;
  }

  void updateUser(String register) =>
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
    this.user = register ?? this.user;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.registerEdited = registerEdited ?? this.registerEdited;
    this.passwordEdited = passwordEdited ?? this.passwordEdited;
    notifyListeners();
  }
}

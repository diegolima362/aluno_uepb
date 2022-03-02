class LoginCredential {
  final String register;
  final String password;
  final bool obscure;

  LoginCredential._({
    required this.register,
    required this.password,
    this.obscure = true,
  });

  bool get isValidRegister => register.isNotEmpty;
  bool get isValidPassword => password.isNotEmpty && password.length >= 6;
  bool get isValid => isValidRegister && isValidPassword;

  factory LoginCredential.withRegisterAndPassword({
    required String register,
    required String password,
    bool obscure = true,
  }) {
    return LoginCredential._(
      register: register,
      password: password,
      obscure: obscure,
    );
  }

  LoginCredential copyWith({
    String? register,
    String? password,
    bool? obscure,
  }) {
    return LoginCredential.withRegisterAndPassword(
      register: register ?? this.register,
      password: password ?? this.password,
      obscure: obscure ?? this.obscure,
    );
  }
}

import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../core/extensions/extensions.dart';
import '../../interactor/actions/auth_actions.dart';
import '../../interactor/atoms/auth_atoms.dart';
import '../components/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with HookStateMixin {
  bool isLoading = false;
  bool obscurePassword = true;
  bool canSubmit = false;

  final usernameFocus = FocusNode();
  final passwordFocus = FocusNode();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameFocus.dispose();
    passwordFocus.dispose();
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    await login(usernameController.text.trim(), passwordController.text);
    setState(() {
      isLoading = false;
    });
  }

  void updateText(String _) {
    setState(() {
      canSubmit = !isLoading &&
          usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    useAtomEffect((get) => get(authResultState), effect: (state) {
      if (state != null) {
        context.showMessage(
          state.fold((s) => s, (e) => e.message),
          () => setAuthResult(null),
        );
      }
    });

    final height = MediaQuery.sizeOf(context).height - kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: const MyAppIcon(),
        centerTitle: true,
        toolbarHeight: 120,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      key: const Key('username_text_field'),
                      decoration: const InputDecoration(
                        labelText: 'Matrícula/Usuário',
                        border: OutlineInputBorder(),
                      ),
                      scrollPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).viewInsets.bottom),
                      focusNode: usernameFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: usernameController,
                      onChanged: updateText,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(
                        passwordFocus,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('password_text_field'),
                      scrollPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).viewInsets.bottom + 64,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() {
                            obscurePassword = !obscurePassword;
                          }),
                          child: Icon(
                            obscurePassword
                                ? Symbols.visibility
                                : Symbols.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: obscurePassword,
                      focusNode: passwordFocus,
                      textInputAction: TextInputAction.done,
                      controller: passwordController,
                      onChanged: updateText,
                      onEditingComplete: canSubmit ? submit : null,
                      validator: (text) => (text?.isEmpty ?? true)
                          ? 'Senha não pode ser vazia'
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          key: const Key('sign_in_button'),
                          onPressed: canSubmit ? submit : null,
                          child: Text(isLoading ? 'Entrando' : 'Entrar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:aluno_uepb/app/core/presenter/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/login_credential.dart';
import 'login_store.dart';

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _idFocusNode = useFocusNode();
    final _passwordFocusNode = useFocusNode();
    final width = useMemoized(() => Modular.get<ResponsiveSize>().w(context));

    final store = Modular.get<LoginStore>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: min(width, 600)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Hero(
                        tag: 'splah_to_login',
                        child: MyAppIcon(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _idFocusNode,
                      onChanged: store.setRegister,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(
                        _passwordFocusNode,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Matrícula',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<LoginCredential>(
                        valueListenable: store.selectState,
                        builder: (_, state, __) {
                          return TextFormField(
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            obscureText: state.obscure,
                            onChanged: store.setPassword,
                            focusNode: _passwordFocusNode,
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              if (state.isValid) {
                                FocusScope.of(context).unfocus();
                                store.enterRegister();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: const OutlineInputBorder(),
                              suffixIcon: Visibility(
                                visible: state.password.isNotEmpty,
                                child: IconButton(
                                  onPressed: store.toggleObscure,
                                  icon: Icon(
                                    state.obscure
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 32),
                    AnimatedBuilder(
                      animation: store.selectState,
                      builder: (context, _) {
                        return FilledButton(
                          context,
                          child: const Text('Entrar'),
                          onPressed: !store.state.isValid
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus();
                                  store.enterRegister();
                                },
                        );
                      },
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

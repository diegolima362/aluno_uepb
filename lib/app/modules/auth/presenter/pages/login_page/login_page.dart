import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/login_credential.dart';
import 'login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final FocusNode _idFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _idFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<LoginStore>();

    final asset = Theme.of(context).brightness == Brightness.dark
        ? 'splash-invert'
        : 'splash';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/$asset.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aluno UEPB',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _idFocusNode,
                  onChanged: store.setRegister,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                  decoration: InputDecoration(
                    labelText: 'Matricula',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: const BorderSide(width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<LoginCredential>(
                    valueListenable: store.selectState,
                    builder: (_, state, __) {
                      return TextField(
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
                          suffixIcon: Visibility(
                            visible: state.password.isNotEmpty,
                            child: IconButton(
                              onPressed: store.toggleObscure,
                              icon: Icon(state.obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(width: 1),
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  child: ValueListenableBuilder<LoginCredential>(
                    valueListenable: store.selectState,
                    builder: (_, state, __) {
                      return ElevatedButton(
                        onPressed: !state.isValid
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                store.enterRegister();
                              },
                        child: const Text('Entrar'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

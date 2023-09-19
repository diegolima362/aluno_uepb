import 'package:asp/asp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../shared/domain/extensions/extensions.dart';
import '../../../../shared/external/datasources/implementations.dart';
import '../../../preferences/atoms/preferences_atom.dart';
import '../../atoms/sign_in_atom.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final FocusNode passwordFocusNode;

  bool _hidePassword = true;
  bool _shouldRedirect = false;

  @override
  void initState() {
    passwordFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      signInResultState
        ..removeListener(resultListener)
        ..addListener(resultListener);
    });

    super.initState();
  }

  void resultListener() {
    final result = signInResultState.value;

    if (result != null) {
      result.fold(
        (user) {
          context.showMessage('Bem vindo!', resetResult);
          usernameState.value = '';
          passwordState.value = '';
        },
        (error) {
          if (error.code == 'anti_span' && !_shouldRedirect) {
            _shouldRedirect = true;
            Modular.to.pushNamed(
              '/auth/sign-in-webview/',
              arguments: {
                'username': usernameState.value,
                'password': passwordState.value,
              },
            ).then((value) => _shouldRedirect = false);
          }
          context.showError(error.message, resetResult);
        },
      );
    }
  }

  void resetResult() {
    signInResultState.value = null;
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    signInResultState.removeListener(resultListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;
    final implementation = context.select(() => implementationState.value);
    final spec = context.select(() => protocolSpecState.value);

    final title = implementation == DataSourceImplementation.openProtocol
        ? spec?.title ?? ''
        : implementation.title;

    return WillPopScope(
      onWillPop: () async {
        Modular.to.navigate('/select/');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Modular.to.navigate('/select/');
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                    maxHeight: height,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: SizedBox(height: 16)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title.split(' ').first.toLowerCase(),
                          textAlign: TextAlign.center,
                          style: context.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Matrícula/Usuário',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        initialValue: usernameState.value,
                        onChanged: usernameState.setValue,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(passwordFocusNode),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: const OutlineInputBorder(),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                              () => _hidePassword = !_hidePassword,
                            ),
                            child: Icon(
                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: context.colors.onSurfaceVariant,
                              size: 24,
                            ),
                          ),
                        ),
                        focusNode: passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        obscureText: _hidePassword,
                        initialValue: passwordState.value,
                        onChanged: passwordState.setValue,
                        onEditingComplete: signInAction.call,
                        validator: (text) => (text?.isEmpty ?? true)
                            ? 'Senha não pode ser vazia'
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: RxBuilder(
                          builder: (context) {
                            if (signInLoadingState.value) {
                              return const SizedBox(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed: isValid ? signInAction.call : null,
                                child: const Text('Entrar'),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

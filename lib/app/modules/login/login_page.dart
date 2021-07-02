import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
      ),
      body: Observer(
        builder: (_) {
          if (controller.loading)
            return LoadingIndicator(text: 'Entrando');
          else
            return _buildContent();
        },
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  SingleChildScrollView _buildContent() {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: width * (portrait ? 1 : .6),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: width * 0.03,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: height * 0.05),
                _buildHeader(),
                SizedBox(height: height * 0.03),
                _buildIdTextField(),
                _buildPasswordTextField(),
                SizedBox(height: 16.0),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Text(
        'Entre com seus dados do\nControle Acadêmico',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildIdTextField() {
    final label = 'Matrícula';
    final hint = 'Insira sua Matrícula';

    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Container(
          width: 300,
          child: TextField(
            enabled: !controller.loading,
            controller: _idController,
            focusNode: _idFocusNode,
            autocorrect: false,
            autofocus: false,
            enableSuggestions: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              enabled: controller.loading == false,
              prefixIcon: Icon(Icons.mail_outline),
              errorText: controller.idError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(width: 3),
              ),
            ),
            onChanged: (value) => controller.editId(value.trim()),
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordFocusNode),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Container(
          width: 300,
          child: TextField(
            enabled: !controller.loading,
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onChanged: (value) => controller.editPassword(value.trim()),
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: 'Insira sua senha',
              errorText: controller.passwordError,
              enabled: controller.loading == false,
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(width: 3),
              ),
            ),
            autocorrect: false,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onEditingComplete:
                !controller.loading ? () async => await _submit() : null,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      width: 300,
      child: ElevatedButton(
        child: Text('Entrar'),
        onPressed: !controller.loading ? () async => await _submit() : null,
      ),
    );
  }

  Future<void> _submit() async {
    try {
      await controller.submit();
    } catch (e) {
      await PlatformAlertDialog(
        title: 'Erro',
        content: Text(controller.errorMsg ?? 'Erro ao logar'),
        defaultActionText: 'OK',
      ).show(context);
    }
  }
}

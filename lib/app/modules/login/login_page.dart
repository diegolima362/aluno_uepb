import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:aluno_uepb/app/shared/components/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;

  const LoginPage({Key? key, this.title = 'Entrar'}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  //use 'controller' variable to access controller

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final bgColor = Color(0xff141414);
  final accent = Colors.white;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(_onWillPop),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: bgColor),
            onPressed: controller.close,
          ),
        ),
        body: Observer(
          builder: (_) {
            if (controller.loading) {
              return LoadingIndicator(
                text: 'Entrando',
              );
            } else {
              if (MediaQuery.of(context).orientation == Orientation.landscape)
                return Center(child: _buildContent());
              else
                return _buildContent();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.setupValidations();
  }

  SingleChildScrollView _buildContent() {
    final portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _width = portrait ? height : null;

    return SingleChildScrollView(
      child: Container(
        width: _width,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Entre com seus dados do controle acadêmico',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              _buildIdTextField(),
              _buildPasswordTextField(),
              SizedBox(height: 16.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Observer _buildIdTextField() {
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
              prefixIcon: Icon(Icons.person_outlined),
              errorText:
                  controller.error.id.isEmpty ? null : controller.error.id,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(width: 3),
              ),
            ),
            onChanged: (value) => controller.editId(value.trim()),
            onEditingComplete: () {
              FocusNode newFocus;
              if (controller.idIdValid) {
                newFocus = _passwordFocusNode;
              } else {
                newFocus = _idFocusNode;
              }
              FocusScope.of(context).requestFocus(newFocus);
            },
          ),
        ),
      ),
    );
  }

  Observer _buildPasswordTextField() {
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
              errorText: controller.error.password.isEmpty
                  ? null
                  : controller.error.password,
              enabled: controller.loading == false,
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
                borderSide: BorderSide(
                  width: 3,
                  color: bgColor,
                ),
              ),
            ),
            autocorrect: false,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onEditingComplete: () async => await _submit(),
          ),
        ),
      ),
    );
  }

  Observer _buildSubmitButton() {
    return Observer(
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: 300,
          child: ElevatedButton(
            child: Text(
              'Entrar',
              style: TextStyle(color: const Color(0xffffffff)),
            ),
            onPressed:
                controller.canSubmit ? () async => await _submit() : null,
          ),
        );
      },
    );
  }

  bool _onWillPop() {
    controller.close();
    return false;
  }

  Future<void> _submit() async {
    final errorTitle = 'Erro ao fazer login';

    try {
      await controller.submit();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: errorTitle,
        exception: e,
      ).show(context);
    }
  }
}

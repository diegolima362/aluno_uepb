import 'package:cau3pb/services/services.dart';
import 'package:cau3pb/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_in_change_model.dart';

class SingInFormChangeNotifier extends StatefulWidget {
  final SignInChangeModel model;

  SingInFormChangeNotifier({@required this.model});

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);

    return ChangeNotifierProvider<SignInChangeModel>(
      create: (_) => SignInChangeModel(auth: auth),
      child: Consumer<SignInChangeModel>(
        builder: (context, model, _) => SingInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _SingInFormChangeNotifierState createState() =>
      _SingInFormChangeNotifierState();
}

class _SingInFormChangeNotifierState extends State<SingInFormChangeNotifier> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _userFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar entrar',
        exception: e,
      ).show(context);
    }
  }

  void _userEditingComplete() {
    final newFocus = model.userValidator.isValid(model.user)
        ? _passwordFocusNode
        : _userFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    final size = MediaQuery.of(context).size;
    return [
      SizedBox(height: size.height * 0.05),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Entre com os dados do controle acadêmico',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24.0,
          ),
        ),
      ),
      SizedBox(height: size.height * 0.03),
      _buildUserTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: size.height * 0.03),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: FormSubmitButton(
          text: 'Entrar',
          onPressed: model.canSubmit ? _submit : null,
        ),
      ),
    ];
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        hintText: 'Senha',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
        prefixIcon: Icon(Icons.lock),
        border: InputBorder.none,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: model.canSubmit ? _submit : null,
    );
  }

  Widget _buildUserTextField() {
    return TextField(
      controller: _userController,
      focusNode: _userFocusNode,
      decoration: InputDecoration(
        hintText: 'Matrícula',
        errorText: model.userErrorText,
        enabled: model.isLoading == false,
        border: InputBorder.none,
        prefixIcon: Icon(Icons.person),
      ),
      autocorrect: false,
      autofocus: false,
      enableSuggestions: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      onChanged: model.updateUser,
      onEditingComplete: () => _userEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }
}

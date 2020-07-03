import 'package:erdm/app/sign_in/sign_in_change_model.dart';
import 'package:erdm/app/sign_in/text_field_container.dart';
import 'package:erdm/common_widgets/form_submit_button.dart';
import 'package:erdm/common_widgets/platform_exception_alert_dialog.dart';
import 'package:erdm/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _registerController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _registerFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _registerController.dispose();
    _passwordController.dispose();
    _registerFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Erro ao tentar entrar',
        exception: e,
      ).show(context);
    }
  }

  void _registerEditingComplete() {
    final newFocus = model.registerValidator.isValid(model.register)
        ? _passwordFocusNode
        : _registerFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    if (model.registerValidator.isValid(model.register) &&
        model.passwordValidator.isValid(model.password)) {
      print('valid');
      _submit();
    } else {
      final newFocus = model.passwordValidator.isValid(model.password)
          ? _registerFocusNode
          : _passwordFocusNode;
      FocusScope.of(context).requestFocus(newFocus);
    }
  }

  List<Widget> _buildChildren() {
    final size = MediaQuery.of(context).size;
    return [
      SizedBox(height: size.height * 0.03),
      SvgPicture.asset(
        "assets/icons/login.svg",
        height: size.height * 0.25,
      ),
      SizedBox(height: size.height * 0.03),
      Center(
        child: Text(
          "Login",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      SizedBox(height: size.height * 0.03),
      _buildRegisterTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: 'Entrar',
        onPressed: model.canSubmit ? _submit : null,
      ),
    ];
  }

  TextFieldContainer _buildPasswordTextField() {
    final primaryColor = Theme.of(context).primaryColor;

    return TextFieldContainer(
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: 'Senha',
          errorText: model.passwordErrorText,
          enabled: model.isLoading == false,
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          border: InputBorder.none,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: model.updatePassword,
        onEditingComplete: model.canSubmit ? _submit : null,
      ),
    );
  }

  TextFieldContainer _buildRegisterTextField() {
    final primaryColor = Theme.of(context).primaryColor;
    return TextFieldContainer(
      child: TextField(
        controller: _registerController,
        focusNode: _registerFocusNode,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: 'Matricula',
          errorText: model.registerErrorText,
          enabled: model.isLoading == false,
          border: InputBorder.none,
          icon: Icon(
            Icons.person,
            color: primaryColor,
          ),
        ),
        autocorrect: false,
        autofocus: false,
        enableSuggestions: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onChanged: model.updateRegister,
        onEditingComplete: () => _registerEditingComplete(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(),
        ),
      ),
    );
  }
}

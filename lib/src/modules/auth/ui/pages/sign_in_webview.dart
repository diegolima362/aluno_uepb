import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../shared/data/datasources/remote_datasource.dart';
import '../../../../shared/external/drivers/http_client.dart';
import '../../atoms/auth_atom.dart';
import '../../atoms/sign_in_atom.dart';
import '../../data/datasources/auth_datasources.dart';
import '../../models/user.dart';

const baseUrl = 'https://pre.ufcg.edu.br:8443/ControleAcademicoOnline/';

class SignInWebView extends StatefulWidget {
  final String? username;
  final String? password;

  const SignInWebView({
    super.key,
    this.username,
    this.password,
  });

  @override
  State<SignInWebView> createState() => _SignInWebViewState();
}

class _SignInWebViewState extends State<SignInWebView>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  late final WebviewCookieManager cookieManager;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    cookieManager = WebviewCookieManager();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (url == baseUrl) {
              _setTextToForm();
            } else {
              _forceReload();
            }
          },
          onNavigationRequest: (request) async {
            if (!request.url.contains('SairDoSistema')) {
              _login();
            }

            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) async {
            if (change.url != baseUrl) {
              _loadFromForm();
            } else {
              _forceReload();
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..addJavaScriptChannel(
        'LoadForm',
        onMessageReceived: (JavaScriptMessage message) {
          final data = message.message.split(':');
          if (data.length == 2) {
            usernameState.value = data[0];
            passwordState.value = data[1];
          }
        },
      )
      ..loadRequest(Uri.parse(baseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _setTextToForm() async {
    final jsCode = '''
      document.getElementById('login').value = '${widget.username ?? ''}';
      document.getElementById('senha').value = '${widget.password ?? ''}';      

      var button = document.querySelector('button.btn.btn-primary.g-recaptcha');
      if (button) {
        button.click();
      }
    ''';

    await _controller.runJavaScript(jsCode);
  }

  void _loadFromForm() async {
    const jsCode = '''
      let username = document.getElementById('login').value;
      let password = document.getElementById('senha').value;

      if (username && password){
        LoadForm.postMessage(username + ':' + password);      
      }
    ''';

    await _controller.runJavaScript(jsCode);
  }

  void _forceReload() async {
    const jsCode = '''
      var button = document.querySelector('.glyphicon-home');
      if (button) {
        button.click();
      }
    ''';

    await _controller.runJavaScript(jsCode);
  }

  void _login() async {
    if (usernameState.value.isEmpty || passwordState.value.isEmpty) {
      return;
    }

    final cookies = await cookieManager.getCookies(baseUrl);

    if (cookies.isNotEmpty) {
      final sessionId =
          cookies.firstWhereOrNull((element) => element.name == 'JSESSIONID');
      if (sessionId != null) {
        Modular.get<AppHttpClient>().setHeader(
          'Cookie',
          '${sessionId.name}=${sessionId.value}',
        );

        final user = User(
          username: usernameState.value,
          password: passwordState.value,
        );

        Modular.get<AcademicRemoteDataSource>().setUser(user);
        Modular.get<AuthLocalDataSource>().save(user);
        userState.setValue(user);
      }
    }
  }
}

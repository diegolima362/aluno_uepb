import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../main.dart';
import '../../../shared/external/datasources/implementations.dart';
import '../../../shared/ui/widgets/my_app_icon.dart';
import '../../auth/atoms/auth_atom.dart';
import '../../preferences/atoms/preferences_atom.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      implementationState
        ..removeListener(preferencesListener)
        ..addListener(preferencesListener);

      fetchPreferences();

      FlutterNativeSplash.remove();
    });
  }

  void preferencesListener() {
    final specs = protocolSpecState.value;
    final implementation = implementationState.value;
    if (implementation != DataSourceImplementation.none) {
      replaceImplementation(implementation, specs);
      fetchCurrentUser();
    } else {
      Modular.to.navigate('/select/');
    }
  }

  @override
  void dispose() {
    implementationState.removeListener(preferencesListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: const Center(
        child: MyAppIcon(),
      ),
    );
  }
}

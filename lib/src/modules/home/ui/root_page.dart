import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.to.navigate('/app/today');
    });

    return const Material(
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

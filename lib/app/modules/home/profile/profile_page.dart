import 'package:aluno_uepb/app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'components/profile_actions.dart';
import 'components/profile_info_card.dart';
import 'components/settings_card.dart';
import 'profile_controller.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  const ProfilePage({Key? key, this.title = "Perfil"}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ModularState<ProfilePage, ProfileController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'Perfil',
      body: Observer(
        builder: (_) {
          if (controller.isLoading) {
            return LoadingIndicator(text: 'Carregando');
          } else if (controller.hasError) {
            return Center(
              child: EmptyContent(
                title: 'Nada por aqui',
                message: 'Erro ao obter dados!',
              ),
            );
          }

          return ListView(
            children: [
              ProfileInfoCard(profile: controller.profile),
              ProfileActionsInfoCard(controller: controller),
              SettingsCard(controller: controller),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../interactor/actions/auth_actions.dart';
import '../../interactor/models/profile.dart';
import 'profile_card.dart';

class ProfileAvatar extends StatelessWidget {
  final Profile profile;

  const ProfileAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      iconSize: 28,
      icon: const Icon(
        Symbols.account_circle,
      ),
      onPressed: () {
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => Dialog(
            backgroundColor: context.colors.surface.withOpacity(.9),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileCard(profile: profile),
                  const Divider(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                  TextButton(
                    onPressed: logout.call,
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

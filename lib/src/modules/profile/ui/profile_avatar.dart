import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/domain/extensions/build_context_extensions.dart';
import '../domain/models/profile.dart';
import 'profile_card.dart';

class ProfileAvatar extends StatelessWidget {
  final Profile profile;

  const ProfileAvatar({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Modular.to.pushNamed('/app/profile/', forRoot: true);
        return;

        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => Dialog(
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
                ],
              ),
            ),
          ),
        );
      },
      icon: CircleAvatar(
        maxRadius: 16,
        backgroundColor: context.colors.onSurface,
        foregroundColor: context.colors.surface,
        child: Text(
          profile.name.isEmpty ? '' : profile.firstName.characters.first,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colors.surface,
          ),
        ),
      ),
    );
  }
}

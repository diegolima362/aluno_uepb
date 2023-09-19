import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../../shared/domain/extensions/extensions.dart';
import '../domain/atoms/profile_atom.dart';
import '../domain/models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    profileResultState
      ..removeListener(resultListener)
      ..addListener(resultListener);

    super.initState();
  }

  void resultListener() {
    final result = profileResultState.value;
    if (result == null) return;

    result.fold(
      (success) => context.showMessage(success, resetResult),
      (error) => context.showError(error.message, resetResult),
    );
  }

  void resetResult() {
    profileResultState.value = null;
  }

  @override
  void dispose() {
    profileResultState.removeListener(resultListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select(() => profileState.value);

    if (profile == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              maxRadius: 48,
              backgroundColor: context.colors.onSurface,
              foregroundColor: context.colors.surface,
              child: Text(
                profile.name.isEmpty ? '' : profile.firstName.characters.first,
                textAlign: TextAlign.center,
                style: context.textTheme.displayMedium?.copyWith(
                  color: context.colors.surface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              profile.program,
              style: context.textTheme.titleSmall,
            ),
            const Divider(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Matrícula'),
                  Text(profile.register),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Carga horária'),
                  Text(profile.totalHours),
                ],
              ),
            ),
            if (profile.credits.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Créditos'),
                    Text(profile.credits),
                  ],
                ),
              ),
            const Divider(
              height: 16,
            ),
            ...profile.academicIndexes.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.label),
                    Text(e.value),
                  ],
                ),
              ),
            ),
            if (!profile.socialProfile)
              FilledButton(
                onPressed: () {
                  createSocialProfileAction();
                },
                child: const Text('Criar perfil social'),
              )
          ],
        ),
      ),
    );
  }
}

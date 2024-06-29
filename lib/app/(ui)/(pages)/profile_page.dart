import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../interactor/actions/profile_actions.dart';
import '../../interactor/atoms/profile_atoms.dart';
import '../../interactor/models/models.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with HookStateMixin {
  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useAtomState(profileLoadingState);
    final profile = useAtomState(profileState);
    final error = useAtomState(profileResultState)?.exceptionOrNull();

    Widget body;
    if (isLoading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (error != null || profile == null) {
      body = Center(child: Text(error.toString()));
    } else {
      body = Padding(
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
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: body,
    );
  }
}

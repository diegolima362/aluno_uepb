import 'package:flutter/material.dart';

import '../../../shared/data/extensions/build_context_extensions.dart';
import '../models/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
    );
  }
}

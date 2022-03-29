import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileCardItem(text: 'Matrícula', value: profile.register),
        const SizedBox(height: 8),
        _ProfileCardItem(text: 'C.R.A.', value: profile.cra),
        const SizedBox(height: 8),
        _ProfileCardItem(text: 'C.H.', value: profile.cumulativeHours),
      ],
    );
  }
}

class _ProfileCardItem extends StatelessWidget {
  final String text;
  final String value;

  const _ProfileCardItem({Key? key, required this.text, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: textTheme.bodyLarge),
          Text(value, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

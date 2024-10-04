import 'dart:ui';

import 'package:asp/asp.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/build_context_extensions.dart';
import '../../interactor/atoms/profile_atoms.dart';
import 'components.dart';

class AppSliverAppbar extends StatelessWidget  with HookMixin{
  final String title;
  final String? subtitle;

  const AppSliverAppbar({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final profile = useAtomState(profileState);

    return SliverAppBar.large(
      backgroundColor: context.colors.surface.withOpacity(0.002),
      stretch: true,
      pinned: true,
      floating: false,
      snap: false,
      title: const MyAppIcon.small(),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: FlexibleSpaceBar(
            background: Padding(
                padding: const EdgeInsets.all(16),
                child: AppBarTitle(
                  title: title,
                  subtitle: subtitle,
                )),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        if (profile != null)
          ProfileAvatar(
            profile: profile,
          ),
      ],
    );
  }
}

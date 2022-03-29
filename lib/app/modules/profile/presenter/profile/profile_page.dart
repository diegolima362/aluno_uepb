import 'package:aluno_uepb/app/core/external/drivers/drift_database.dart';
import 'package:aluno_uepb/app/core/presenter/stores/preferences_store.dart';
import 'package:aluno_uepb/app/modules/auth/domain/usecases/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fpdart/fpdart.dart' as fpdart;

import '../../../../core/presenter/widgets/widgets.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/errors/errors.dart';
import '../widgets/widgets.dart';
import 'profile_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ModularState<ProfilePage, ProfileStore> {
  @override
  void initState() {
    super.initState();

    store.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Modular.to.pushNamed(
              '/root/preferences/',
              forRoot: true,
            ),
          ),
        ],
      ),
      body: ScopedBuilder<ProfileStore, ProfileFailure,
          fpdart.Option<ProfileEntity>>(
        store: store,
        onError: (_, error) => EmptyCollection.error(message: error?.message),
        onLoading: (context) => const Center(child: Text('Carregando')),
        onState: (context, state) {
          final profile = state.toNullable();
          if (profile == null) {
            return EmptyCollection.error();
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'ProfileAvatar',
                            child: ProfileHeader(profile: profile),
                          ),
                        ),
                        const SizedBox(height: 32),
                        ProfileBody(profile: profile),
                      ],
                    ),
                  ),
                  const Divider(height: 8),
                  ListTile(
                    title: const Text('Histórico'),
                    trailing: const Icon(Icons.school_outlined),
                    onTap: () => Modular.to.pushNamed(
                      '/root/history/',
                      forRoot: true,
                    ),
                  ),
                  ListTile(
                    title: const Text('Sair'),
                    trailing: const Icon(Icons.logout_outlined),
                    onTap: () async => await signOut(context),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> signOut(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que quer sair?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Sair'),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await Modular.get<PreferencesStore>().setTheme(ThemeMode.system);

    await Modular.get<ILogout>().call();
    await Modular.get<AppDriftDatabase>().clearDatabase();

    Navigator.pop(context);
    Modular.to.navigate('/');
  }
}

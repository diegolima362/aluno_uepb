import 'package:aluno_uepb/app/core/presenter/widgets/my_app_icon.dart';
import 'package:aluno_uepb/app/modules/profile/domain/types/types.dart';
import 'package:aluno_uepb/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootPage extends HookWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);
    final future = useMemoized(() => Modular.get<GetProfile>()());
    final state = useFuture(future);

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex.value == 0) {
          return true;
        } else {
          Modular.to.navigate('/root/courses/');
          currentIndex.value = 0;
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const SizedBox(
            width: 100,
            child: MyAppIcon(height: 32, width: 100),
          ),
          centerTitle: true,
          actions: [
            Hero(
              tag: 'ProfileAvatar',
              child: IconButton(
                icon: ProfileIcon(state: state),
                tooltip: 'Exibir perfil',
                onPressed: () => Modular.to.pushNamed(
                  '/root/profile/',
                  forRoot: true,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: const RouterOutlet(),
          ),
        ),
        bottomNavigationBar: Material(
          elevation: 2,
          child: NavigationBar(
            selectedIndex: currentIndex.value,
            onDestinationSelected: (index) {
              currentIndex.value = index;
              onDestinationSelected(index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_filled),
                label: 'Início',
                tooltip: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_sharp),
                label: 'RDM',
                tooltip: 'RDM',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_sharp),
                label: 'Lembretes',
                tooltip: 'Lembretes',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDestinationSelected(int index) {
    if (index == 0) {
      Modular.to.navigate('/root/courses/');
    } else if (index == 1) {
      Modular.to.navigate('/root/courses/rdm/');
    } else if (index == 2) {
      Modular.to.navigate('/root/alerts/');
    }
  }
}

class ProfileIcon extends StatelessWidget {
  final AsyncSnapshot<EitherProfile> state;
  const ProfileIcon({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = state.data;
    if (data != null && data.isRight()) {
      final p = data.getRight().toNullable()?.toNullable();

      if (p != null && p.name.isNotEmpty) {
        return CircleAvatar(
          child: Text(
            p.name[0],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          foregroundColor: Theme.of(context).colorScheme.surfaceVariant,
        );
      }
    }

    return const Icon(Icons.account_circle);
  }
}

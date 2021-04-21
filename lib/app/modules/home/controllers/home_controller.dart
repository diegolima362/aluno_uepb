import 'package:aluno_uepb/app/shared/repositories/data_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  int currentIndex = 0;

  @observable
  bool loading = true;

  _HomeControllerBase() {
    loadData();
  }

  @action
  Future<void> loadData() async {
    print('> HomeController: get all data');
    setLoading(await Modular.get<DataController>().getAllData());
  }

  @action
  void setLoading(bool value) => loading = value;

  @action
  void updateIndex(int value) => currentIndex = value;

  void onTap(int id) {
    updateIndex(id);
    if (id == 0) {
      Modular.to.navigate('content');
    } else if (id == 1) {
      Modular.to.navigate('rdm');
    } else if (id == 2) {
      Modular.to.navigate('reminders');
    } else if (id == 3) {
      Modular.to.navigate('profile');
    }
  }

  bool onWillPop() {
    if (currentIndex == 0)
      return true;
    else {
      Modular.to.navigate('content');
      updateIndex(0);
      return false;
    }
  }
}

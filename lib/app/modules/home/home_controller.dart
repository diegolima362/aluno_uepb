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
  bool loading;

  _HomeControllerBase() {
    loading = true;

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
  void updateCurrentIndex(int index) => this.currentIndex = index;
}
